//
//  HttpRequestTests.swift
//  MobileDataDemoTests
//
//  Created by jhm on 2021/5/21.
//  Copyright © 2021 jhm. All rights reserved.
//

import XCTest



class HttpRequestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
//    func testFullUrl () throws {
//        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
//        let testReq = HMURLRequest<Bean>("https://data.gov.sg/api/action/datastore_search",param,.GET)
//        testReq.startWithSuccess(success: { (bean) in
//
//        }, fail: { (any) in
//
//        }) { (error) in
//
//        }
//    }
    
    func testSuccessBlock () throws {
        let exception = XCTestExpectation(description: "超时")
        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
        let testReq = HMURLRequest<Bean>("https://data.gov.sg/api/action/datastore_search",param,.GET,10)
        testReq.startWithSuccess(success: { (bean) in
                   exception.fulfill()
                   XCTAssertTrue(true)
        }, fail: { (any,cause) in
                   exception.fulfill()
                   XCTAssertTrue(false)
        }) { (error) in
                   exception.fulfill()
                   XCTAssertTrue(false)
        }
        self.wait(for: [exception], timeout: 12)
    }
    
    func testRequestBody() throws {
       
        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
        let testReq = HMURLRequest<Bean>("https://data.gov.sg/api/action/datastore_xxsearch",param,.POST,10)
        testReq.startWithSuccess(success: { (bean) in
           
        }, fail: { (any,cause) in
               
        }) { (error) in
                
        }
              
    }
    
    func testError() throws {
        let exception = XCTestExpectation(description: "超时")
        let testReq = HMURLRequest<Bean>("http://xxdkx.1sxi2.com/aa.html", [:])
        testReq.startWithSuccess(success: { (bean) in
            exception.fulfill()
            XCTAssertTrue(false)
        }, fail: { (any,cause) in
            exception.fulfill()
            XCTAssertTrue(false)
        }) { (error) in
            exception.fulfill()
            XCTAssertTrue(true)
        }
        
        self.wait(for: [exception], timeout: 30)
    }
    
    func testFailBlock() throws {
       
        let exception = XCTestExpectation(description: "超时")
        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
        let testReq = HMURLRequest<Bean>("https://data.gov.sg/api/action/datastore_xxsearch",param,.GET,10)
        testReq.startWithSuccess(success: { (bean) in
            exception.fulfill()
            XCTAssertTrue(false)
        }, fail: { (any,cause) in
            exception.fulfill()
            XCTAssertTrue(true)
        }) { (error) in
            exception.fulfill()
            XCTAssertTrue(false)
        }
        self.wait(for: [exception], timeout: 12)
        
   
    }
    func testHttpRequest() throws {
        let param = ["resource_id":"a807b7ab-6cad-4aa6-87d0-e283a7353a0f","limit":"120"]
        let testReq = HMURLRequest<Bean>("/api/action/datastore_search",param,.GET)
        testReq.startWithSuccess(success: { (bean) in

        }, fail: { (any,cause) in

        }) { (error) in

        }
    }
    
    func testResponseSerialType() throws {
        let testReq = HMURLRequest<Bean>("/api/action/datastore_search",[:],.GET)
        XCTAssert(testReq.responseSerializerType() == .JSON)
    }
    
    func testGetTask() throws {
        let testReq = HMURLRequest<Bean>("/api/action/datastore_search",[:],.GET)
        let task:URLSessionTask? = testReq.task
        
        XCTAssertTrue(true)
    }
    
    func testRequestSerialType() throws {
        let testReq = HMURLRequest<Bean>("/api/action/datastore_search",[:],.GET)
        XCTAssert(testReq.requestSerializerType() == .HTTP)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
