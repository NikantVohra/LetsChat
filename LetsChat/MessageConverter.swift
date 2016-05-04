//
//  MessageConverter.swift
//  LetsChat
//
//  Created by Vohra, Nikant on 4/29/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

import Foundation

//The MessageConverter is a Singleton class that handles the conversion of a chat message to a JSON string containing information about its contents.

class MessageConverter {
    
    static let sharedInstance = MessageConverter()
    let maxEmoticonLength = 15
    
    /*
     
    Converts a given chat message to a JSON string containing information about various properties : mentions, emoticons and links.
    
    Args : 
     message(String) : The input chat message
    Output :
     Optional String on completion : JSON string containing information about message properties. Returns nil on encountering an error.
    
    */
    internal func convertMessage(message : String, completion: (result : String?) -> Void) {
        var jsonMessageDict = Dictionary<String, AnyObject>()
        
        let mentions = detectMentions(message)
        if mentions.count > 0 {
            jsonMessageDict["mentions"] = mentions
        }
        
        let emoticons = detectEmoticons(message)
        if emoticons.count > 0 {
            jsonMessageDict["emoticons"] = emoticons
        }
        
        detectLinks(message) { (result) in
            if result.count > 0 {
                jsonMessageDict["links"] = result
            }
            do {
                let decodedJson = try NSJSONSerialization.dataWithJSONObject(jsonMessageDict, options: [])
                if let convertedMessage = NSString(data: decodedJson, encoding: NSUTF8StringEncoding) {
                    completion(result: convertedMessage as String)
                }
            } catch let error as NSError {
                print(error)
                completion(result: nil)

            }

        }
        
    }
    
    
    /*
     
     Detects the presence of mentions in the message and returns all the mentions in an Array
     
     Args :
     message(String) : The input chat message
     Output :
     Array of Strings : Array containting the mentions as String
     
     */
    
    private func detectMentions(message : String) -> [String]{
        var mentions = [String]()
        let matches = detectRegexMatches(message, pattern:  "@(\\w+)")
        for match in matches {
            let mentionRange = match.range
            mentions.append(message.substringWithRange(message.rangeFromNSRange(NSMakeRange(mentionRange.location + 1, mentionRange.length - 1))!))
            
        }
        return mentions
    }
    
    
    /*
     
     Detects the presence of emoticons in the message and returns all the emoticons in an Array
     
     Args :
     message(String) : The input chat message
     Output :
     Array of Strings : Array containing the emoticons as String
    
    */
    
    private func detectEmoticons(message : String) -> [String]{
        var emoticons = [String]()
        let matches = detectRegexMatches(message, pattern:  "\\((\\w+?)\\)")
        for match in matches {
            let emoticonRange = match.range
            //Emoticons above 15 alphanumeric characters in length are not considered
            let emoticon = message.substringWithRange(message.rangeFromNSRange(NSMakeRange(emoticonRange.location + 1, emoticonRange.length - 2))!)
            if(emoticon.characters.count <= maxEmoticonLength && emoticon.isAlphanumeric) {
                emoticons.append(emoticon)
            }
        }
        return emoticons
    }
    
    /*
     
     Detects the presence of links in the message and returns an Array containing the Dictionaries of the url and the title attributes of the links
     
     Args :
     message(String) : The input chat message
     Output :
     Array of Dictionaries [[String : String]] : Array containing the Dictionaries of the url and the title attributes of the links
     
    */
    
    private func detectLinks(message : String, completion: (result: [[String : String]] ) -> Void)  {
        var links = [[String : String]]()
        let types: NSTextCheckingType = .Link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        
        if let detect = detector  {
            let matches = detect.matchesInString(message, options: .ReportCompletion, range: NSMakeRange(0, message.characters.count))
            var titlesFetched = 0
            if(matches.count  > 0) {
                for match in matches {
                    let urlRange = match.range
                    let url = message.substringWithRange(message.rangeFromNSRange(NSMakeRange(urlRange.location, urlRange.length))!)
                    fetchLinkTitle(url, completion: { (result) in
                        if let linkTitle = result {
                             links.append(["url" : url, "title" : linkTitle])
                        }
                        else {
                            links.append(["url" : url, "title" : ""])

                        }
                        titlesFetched = titlesFetched + 1
                        if(titlesFetched == matches.count) {
                            completion(result: links)
                        }
                        
                    })
                }
            }
            else {
                completion(result: [])
            }

        }

    }
    
    /*
     
     Fetches the title of the webpage from the url
     
     Args :
     url(String) : The url of the webpage
     Output :
     Optional String : Title of the webpage
     
    */

    private func fetchLinkTitle(url : String, completion: (result: String?) -> Void)  {

        let urlWebpage = NSURL(string: url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(urlWebpage!) {(data, response, error) in
            if(error == nil) {
                let htmlSourceString = NSString(data: data!, encoding: NSASCIIStringEncoding) as! String
                let titleMatch = self.detectRegexMatches(htmlSourceString, pattern: "<title>(.*?)</title>")
                if titleMatch.count > 0 {
                    let titleRange = titleMatch[0].range
                    let title =  htmlSourceString.substringWithRange(htmlSourceString.rangeFromNSRange(NSMakeRange(titleRange.location + "<title>".characters.count, titleRange.length - "</title>".characters.count - "<title>".characters.count ))!)
                    completion(result: title)
                }
                else {
                    completion(result: nil)

                }
            
            }
        }
        task.resume()
    }
    
    
    /* 
     
     Find all the matches of a pattern(regular expression) in a string.
     Args :
     message(String) : The input message , pattern(String) : The regex to be detected in the messafe
     Output :
     Array  [NSTextCheckingResult] : Returns an array containing the matched ranges of the regex in the form of NSTextCheckingResult
     
    */
    private func detectRegexMatches(message : String, pattern : String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matchesInString(message, options: [], range: NSMakeRange(0, message.characters.count))
        return matches
    }
    
    
    
    
    
    
}
 // A custom String extension containing a method to convert NSRange to Range<String.Index> for using the substring method on the String object.

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    var isAlphanumeric: Bool {
        return rangeOfString("^[a-zA-Z0-9]+$", options: .RegularExpressionSearch) != nil
    }
}