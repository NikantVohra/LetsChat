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

    
    func testMentions() {
        let message = "@chris you around?"
        let result = jsonToDict(MessageConverter.sharedInstance.convertMessage(message)!)
        let expected = ["mentions" : ["chris"]] as Dictionary<String, NSObject>
        XCTAssertEqual(result, expected)
    }
    
    func testEmoticons() {
        let message = "Good morning! (megusta) (coffee)"
        let result = jsonToDict(MessageConverter.sharedInstance.convertMessage(message)!)
        let expected = ["emoticons" : ["megusta", "coffee"]] as Dictionary<String, NSObject>
        XCTAssertEqual(result, expected)
        
    }
    
    func testLinks() {
        let message = "Olympics are starting soon;http://www.nbcolympics.com"
        let result = jsonToDict(MessageConverter.sharedInstance.convertMessage(message)!)
        let expected = ["links" : [[ "url": "http://www.nbcolympics.com", "title": "2016 Rio Olympic Games | NBC Olympics"]]] as Dictionary<String, NSObject>
        XCTAssertEqual(result, expected)
        
    }
    
    func testMisc() {
        let message = "@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"
        let result = jsonToDict(MessageConverter.sharedInstance.convertMessage(message)!)
        let expected = ["mentions" :["bob", "john"], "emoticons":["success"], "links" : [[ "url": "https://twitter.com/jdorfman/status/430511497475670016", "title": "Justin Dorfman on Twitter: &quot;nice @littlebigdetail from @HipChat (shows hex colors when pasted in chat). http://t.co/7cI6Gjy5pq&quot;"]]] as Dictionary<String, NSObject>
        XCTAssertEqual(result, expected)
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
