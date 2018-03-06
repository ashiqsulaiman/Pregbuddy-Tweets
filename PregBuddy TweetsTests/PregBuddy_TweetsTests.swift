//
//  PregBuddy_TweetsTests.swift
//  PregBuddy TweetsTests
//
//  Created by Ashiq Sulaiman on 06/03/18.
//  Copyright © 2018 Ashiq Sulaiman. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
import UIKit

@testable import PregBuddy_Tweets

class PregBuddy_TweetsTests: XCTestCase {
    let network = Network()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Test if the response returnned is nil
    func testServerResponse(){
        let expectationForAsync = expectation(description: "fetches the tweets from the backend and runs the closure")
        network.searchTweet { (responseData) in
            guard let data = responseData else {return}
            XCTAssertNotNil(data)
            expectationForAsync.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
}
