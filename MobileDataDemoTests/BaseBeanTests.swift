//
//  BaseBeanTests.swift
//  MobileDataDemoTests
//
//  Created by jhm on 2021/5/21.
//  Copyright © 2021 jhm. All rights reserved.
//

import XCTest
import SwiftyJSON


class BaseBeanTests: XCTestCase {
    //服务器返回JSON对象
    var _json:JSON!
    var responseJson:JSON {
        get {
            if (_json == nil) {
                let path = Bundle.main.path(forResource: "response", ofType: ".json")
                let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
                _json = JSON(data!)
            }
            return _json;
        }
    }
    

    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecordInit() throws {
        let json = JSON(parseJSON:"""
                            {
                            "volume_of_mobile_data": "0.000384",
                            "quarter": "2010-Q1",
                            "_id": 1
                            }
                        """
                        )
          XCTAssertNoThrow(try Record(json))
        
    }
    
    func testRecordOper() throws {
        let jsonStr1 =  """
                                 {
                                    "volume_of_mobile_data": "0.000383",
                                    "quarter": "2010-Q1",
                                    "_id": 1
                                  }
                             """
             
        let jsonStr2 =  """
                                       {
                                          "volume_of_mobile_data": "0.000384",
                                          "quarter": "2015-Q2",
                                          "_id": 1
                                        }
                                   """
        var json1 = JSON(parseJSON:jsonStr1)
        let json2 = JSON(parseJSON:jsonStr2)
        
        XCTAssert(try (Record(json1) <= Record(json2)))
        json1["volume_of_mobile_data"] = "0.000384"
        XCTAssert(try (Record(json1) <= Record(json2)))
              
    }
    func testRecordInitError() throws {
        let jsonStr1 =  """
                            {
                               "volume_of_mobile_data": "0.000384",
                               "quarter": nil,
                               "_id": 1
                             }
                        """
        
        let jsonStr2 =  """
                                  {
                                     "volume_of_mobile_data": "0.000384",
                                     "quarter": "aa",
                                     "_id": 1
                                   }
                              """
         
   
        let json1 = JSON(parseJSON:jsonStr1)
        let json2 = JSON(parseJSON:jsonStr2)
        
        XCTAssertThrowsError(try Record(json1))
        XCTAssertThrowsError(try Record(json2))

    }
    
    
    func testResourceInit() throws {
        var json = self.responseJson
        var result = json["result"]
        XCTAssertNoThrow(try Resource(result))
        result["limit"] = "nil"
        result["resource_id"] = "nil"
        result["records"] = "nil"
        result["total"] = "nil"
        
        XCTAssertNoThrow(try Resource(result))
        
        
        
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
