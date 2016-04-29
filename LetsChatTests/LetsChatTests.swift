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
//    func testMentions() {
////        let message = "@chris you around?"
////        let result = jsonToDict(MessageConverter.sharedInstance.convertMessage(message)!)
////        let expected = ["mentions" : "chris"] as NSDictionary
////        XCTAssertEqual(expected ,  result )
//    }
    
    
    
    
    func jsonToDict(json : String) -> NSDictionary {
        if let data = json.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
            } catch let error as NSError {
                print(error)
            }
        }
        return NSDictionary()
    }
    

    
}
