//
//  BaseBean.swift
//  MobileData
//
//  Created by jhm on 2021/5/21.
//

import Foundation
import SwiftyJSON

enum  DataSourceError : Error {
    case DataSourceError_Json_null
    case DataSourceError_Record_quarter
}

/// 季度地象模型
class Record {
    var volume_of_mobile_data:NSNumber      //使用情况
    var quarter:String                      //2008-01
    var _id:Int;
    init(_ json:JSON) throws {
        let quar = json["quarter"].string
        if (quar == nil || quar!.count != 7) {  //季度标识为空或者格式不对时抛出错误
            throw DataSourceError.DataSourceError_Record_quarter
        }
        let num = json["volume_of_mobile_data"].numberValue
        self.volume_of_mobile_data =  num
        
        self.quarter = quar!
        self._id = json["_id"].intValue
    }
    
    /// 通过重载操作符进行季度流量比较
    /// - Parameters:
    ///   - left: left description
    ///   - right: right description
    /// - Returns:true/false
    static func <= (left: Record, right: Record) -> Bool {

        let result  = left.volume_of_mobile_data.compare(right.volume_of_mobile_data)
        return (ComparisonResult.orderedAscending == result || ComparisonResult.orderedSame == result)
    }
    
}

class Resource {
    var resource_id:String
    var limit:Int
    var total:Int
    var records:[Record]
    
    init(_ json:JSON) {
        self.resource_id = json["resource_id"].string ?? ""
        self.limit = json["limit"].int ?? 0
        self.total = json["total"].int ?? 0
        self.records = [Record]();
        let array = json["records"].arrayValue
        for item in array {
            let record = try?Record(item)
            if (record != nil) {
                self.records.append(record!)
            }
        }

        
        
    }
}


//返回数据接口
protocol IBean {
    init(_ json:JSON);
}

/// 同一项目中多数接口都返回的是相同结构，故此处设计一个Bean其类，进行一些公共处理
class Bean:IBean{

    var success:Bool        //!<逻辑是否成功
    var result:Resource;    //
    var errorMessage:String //!<错误消息

    
    required init(_ json: JSON) {
        self.success = json["success"].bool ?? false
        self.result = Resource(json["result"])
        self.errorMessage = ""

    }


    
}
