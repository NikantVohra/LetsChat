//
//  LetsChatTests.swift
//  LetsChatTests
//
//  Created by Vohra, Nikant on 4/29/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

import XCTest
@testable import LetsChat

class LetsChatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
//    
    func testMentions() {
        let asyncExpectation = expectationWithDescription("testMentionsExpectation")
        let message = "@chris you around?"
        var resultDict = Dictionary<String, NSObject>()
        MessageConverter.sharedInstance.convertMessage(message) { (result) in
            resultDict = self.jsonToDict(result!)
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(5) { (error) in
            let expected = ["mentions" : ["chris"]] as Dictionary<String, NSObject>
            XCTAssertEqual(resultDict, expected)
        }
        
    }

    func testEmoticons() {
        let asyncExpectation = expectationWithDescription("testEmoticonsExpectation")
        let message = "Good morning! (megusta) (coffee)"
        var resultDict = Dictionary<String, NSObject>()
        MessageConverter.sharedInstance.convertMessage(message) { (result) in
            resultDict = self.jsonToDict(result!)
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(5) { (error) in
            let expected = ["emoticons" : ["megusta", "coffee"]] as Dictionary<String, NSObject>
            XCTAssertEqual(resultDict, expected)
        }
        
    }

    func testLinks() {
        let asyncExpectation = expectationWithDescription("testLinksExpectation")
        let message = "Olympics are starting soon;http://www.nbcolympics.com"
        var resultDict = Dictionary<String, NSObject>()
        MessageConverter.sharedInstance.convertMessage(message) { (result) in
            resultDict = self.jsonToDict(result!)
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(5) { (error) in
            let expected = ["links" : [[ "url": "http://www.nbcolympics.com", "title": "2016 Rio Olympic Games | NBC Olympics"]]] as Dictionary<String, NSObject>
            XCTAssertEqual(resultDict, expected)
        }

        
    }

    func testMisc() {
        let asyncExpectation = expectationWithDescription("testMiscExpectation")
        let message = "@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"
        var resultDict = Dictionary<String, NSObject>()
        MessageConverter.sharedInstance.convertMessage(message) { (result) in
            resultDict = self.jsonToDict(result!)
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(5) { (error) in
            let expected = ["mentions" :["bob", "john"], "emoticons":["success"], "links" : [[ "url": "https://twitter.com/jdorfman/status/430511497475670016", "title": "Justin Dorfman on Twitter: &quot;nice @littlebigdetail from @HipChat (shows hex colors when pasted in chat). http://t.co/7cI6Gjy5pq&quot;"]]] as Dictionary<String, NSObject>
            XCTAssertEqual(resultDict, expected)
        }
    }
    
    func jsonToDict(json : String) -> Dictionary<String, NSObject> {
        if let data = json.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, NSObject>
            } catch let error as NSError {
                print(error)
            }
        }
        return Dictionary<String, NSObject>()
    }
    
    
    
    
}
