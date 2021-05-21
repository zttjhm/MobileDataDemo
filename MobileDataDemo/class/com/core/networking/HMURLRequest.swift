//
//  HMURLRequest.swift
//  MobileData
//
//  Created by jhm on 2021/5/21.
//


import Foundation
import SwiftyJSON


enum HMURLRequestMethod {
    case GET
    case POST
}

enum HMURLRequestSerializerType {
    case HTTP
    case JSON
}

enum HMResponseSerializerType {
   case  JSON
}


var session:URLSession?
var config:URLSessionConfiguration?

class HMURLRequest<T:IBean> : NSObject {
       
    
    typealias successBlock = (_ bean:T)->Void
    typealias failBlock = (_ any:Any?)->Void
    typealias errorBlock = (_ error:Error)->Void
    
   
  
    
    private var requestSessionTask:URLSessionDataTask?
    private var relativeUrl:String
    private var timeout:TimeInterval  //超时时间
    private var params:[String:String]
    private var requestMethod:HMURLRequestMethod
    private var success:successBlock?
    private var fail:failBlock?
    private var error:errorBlock?
   
 
  
    init(_ relativeUrl:String,
         _ params:[String:String],
         _ method: HMURLRequestMethod = HMURLRequestMethod.GET,
         _ timeout:TimeInterval = 60) {
        self.requestMethod = method
        self.relativeUrl = relativeUrl
        self.timeout = timeout
        self.params = params
    
     
        
        
    }
    
    func requestMethodStr()->String {
        switch self.requestMethod {
            case .POST: return "POST"
            case .GET:  return "GET"
        }
        
    }
    
    /// 服务器返回的数据格式
    /// - Returns: 目前暂时只支持JSON
    func responseSerializerType()->HMResponseSerializerType {
        return .JSON
    }
    
    /// 请求格式
    /// - Returns: HTTP或JSON
    func requestSerializerType()->HMURLRequestSerializerType {
        return .HTTP
    }
    //子类需重写
    func httpHeader()->[String:String] {
        return ["abc":"def"]
    }
    //针对部分后台，会通过修改StatusCode来判断成功与否，故此处抽离出来，不同业务可以重载返回不同结果
    func httpOK()->[Int] {
        return [200]
    }
 

    
    /// 接口请求基地址
    /// - Returns: <#description#>
    func BaseUrl()->String {
        return "https://data.gov.sg/"
    }
    
    /// 返回接口全地址
    /// - Returns: <#description#>
    func URLString()->String! {
        let strUrl = self.relativeUrl.lowercased()
        if (strUrl.hasPrefix("http://") || strUrl.hasPrefix("https://")) {
            return self.relativeUrl
        }
        let strURL = self.BaseUrl()
        let baseUrl = URL(string: strURL);
        let url = URL(string: self.relativeUrl, relativeTo: baseUrl)
        if (url == nil) {
            return  ""
        }
        return url!.absoluteString;
    }
    
    
    
    /// 开始一个网络请求
    /// - Parameters:请求参数
    ///   - success: 成功回调
    ///   - fail: 失败回调
    ///   - error: 错误回调
    func startWithSuccess(success:@escaping successBlock,
                           fail:@escaping failBlock,
                           error:@escaping errorBlock) {
        self.success = success
        self.fail = fail
        self.error = error
        
        if (self.configRequest()) {
            
        }
        self.requestSessionTask?.resume();
      
    }
    
    
  
    
    /// 处理网络请求
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - response: <#response description#>
    ///   - error: <#error description#>
    /// - Returns: <#description#>
    func handleRequestResult(_ data: Data?, _ response: URLResponse?, _ error: Error?)->Void {
        if (error != nil) {
            self.error!(error!)
        }
        if (response != nil && (response is HTTPURLResponse)) {
            let respon = response as! HTTPURLResponse
            if (self.httpOK().contains(respon.statusCode)) {
                if (.JSON == self.responseSerializerType()) {
                    let json = try?JSON(data: data!)
                    if (json != nil) {
                        let bean = T(json!)
                        if (self.logicSuccess(bean as! Bean)) {
                            DispatchQueue.main.sync {
                                self.success?(bean)
                            }
                            
                        } else {
                            DispatchQueue.main.sync {
                                self.fail?(bean)
                            }
                        }
                             
                    }
                          
                }
            } else {
                DispatchQueue.main.sync {
                    self.fail?(data!)
                }
            }
        } else {
            DispatchQueue.main.sync {
                self.fail?(data)
            }
        }
        
       
    }
    
    
    
    /// 同一应用大部分接口返回数据相同格式，此处进行一个业务逻辑成功/失败判断，
    /// 判断业务逻辑是否成功
    /// - Parameter bean: 返回的bean对象
    /// - Returns: true/false 业务逻辑成功/失败
    func logicSuccess(_ bean:Bean)->Bool {
        return bean.success
    }
    
    
    /// 用于POST请求的 body块
    /// - Returns: <#description#>
    func httpBody() -> Data? {
        let postDic = self.params;
        if (self.requestSerializerType() == .JSON) {
            let jsonData = try? JSONSerialization.data(withJSONObject: postDic, options:.prettyPrinted) as Data?
            return jsonData
        }
        return nil;
     

    }
    
    
    /// URLSession单例对象
    /// - Returns: <#description#>
    static func shareSession()->URLSession {
          
        if session == nil {
            if config == nil {
                config = URLSessionConfiguration.default
            }
            session = URLSession(configuration: config!)
        }
        return session!
    }
    
    /// 创建一个任务
    /// - Parameter error: <#error description#>
    /// - Returns: <#description#>
    func createSessionTask(_ error:inout NSError)->URLSessionDataTask? {
        //1、创建URL下载地址
        let url:URL! = URL(string:self.URLString())
              
        //2、创建Request对象
        var request:URLRequest = URLRequest(url:url)
        request.timeoutInterval = self.timeout
        request.httpMethod = self.requestMethodStr()
        request.allHTTPHeaderFields = self.httpHeader()
        if (HMURLRequestMethod.GET == self.requestMethod) {

            let urlComp = NSURLComponents(string: self.URLString()!)
            var items = [URLQueryItem]()
            for (key,value) in self.params {
                items.append(URLQueryItem(name: key, value: value))
            }
            items = items.filter{!$0.name.isEmpty}

            if !items.isEmpty {
                urlComp?.queryItems = items
            }
            request.url = urlComp?.url

        } else {
            request.httpBody = self.httpBody()
        }
       
        
        request.cachePolicy = .returnCacheDataElseLoad
              
        self.requestSessionTask =  HMURLRequest.shareSession().dataTask(with: request, completionHandler: { (_ data: Data?, _ response: URLResponse?, _ error: Error?) in
            
            self.handleRequestResult(data,response,error)
        })
        
        return self.requestSessionTask;
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func configRequest()->Bool {
        var error = NSError();
        self.requestSessionTask = self.createSessionTask(&error)
        return self.requestSessionTask != nil;
    }
    

    
   
    
}
