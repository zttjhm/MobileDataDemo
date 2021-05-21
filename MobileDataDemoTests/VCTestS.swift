//
//  VCTestS.swift
//  MobileDataDemoTests
//
//  Created by jhm on 2021/5/21.
//  Copyright © 2021 jhm. All rights reserved.
//

import XCTest

class VCTestS: XCTestCase {
    
    var vc:ViewController?
    override func setUpWithError() throws {
        self.vc = ViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
       
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRightBarItemClick() throws {
       
        self.vc?.onRightItemAction()
    }
    
    func testVCInitDataSource() throws {
        self.vc?.initDataSource()
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
