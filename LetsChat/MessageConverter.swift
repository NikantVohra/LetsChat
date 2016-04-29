//
//  MessageConverter.swift
//  LetsChat
//
//  Created by Vohra, Nikant on 4/29/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

import Foundation
class MessageConverter {
    
    static let sharedInstance = MessageConverter()
    static let maxEmoticonLength = 15
    
    internal func convertMessage(message : String) -> String? {
        var jsonMessageDict = Dictionary<String, AnyObject>()
        
        let mentions = detectMentions(message)
        if mentions.count > 0 {
            jsonMessageDict["mentions"] = mentions
        }
        
        let emoticons = detectEmoticons(message)
        if emoticons.count > 0 {
            jsonMessageDict["emoticons"] = emoticons
        }
        
        let links = detectLinks(message)
        if links.count > 0 {
            jsonMessageDict["links"] = links
        }

        
        do {
            let decodedJson = try NSJSONSerialization.dataWithJSONObject(jsonMessageDict, options: [])
            if let result = NSString(data: decodedJson, encoding: NSUTF8StringEncoding) {
                return result as String
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    
    
    private func detectMentions(message : String) -> [String]{
        var mentions = [String]()
        let matches = detectRegexMatches(message, pattern:  "@(\\w+)")
        for match in matches {
            let mentionRange = match.range
            mentions.append(message.substringWithRange(message.rangeFromNSRange(NSMakeRange(mentionRange.location + 1, mentionRange.length - 1))!))
            
        }
        return mentions
    }
    
    private func detectEmoticons(message : String) -> [String]{
        var emoticons = [String]()
        let matches = detectRegexMatches(message, pattern:  "\\((\\w+?)\\)")
        for match in matches {
            let emoticonRange = match.range
            emoticons.append(message.substringWithRange(message.rangeFromNSRange(NSMakeRange(emoticonRange.location + 1, emoticonRange.length - 2))!))
            
        }
        return emoticons
    }
    
    private func detectLinks(message : String) -> [[String : String]] {
        var links = [[String : String]]()
        let types: NSTextCheckingType = .Link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        
        if let detect = detector  {
            let matches = detect.matchesInString(message, options: .ReportCompletion, range: NSMakeRange(0, message.characters.count))
            
            for match in matches {
                let urlRange = match.range
                let url = message.substringWithRange(message.rangeFromNSRange(NSMakeRange(urlRange.location, urlRange.length))!)
                if let linkTitle = fetchLinkTitle(url) {
                    links.append(["url" : url, "title" : linkTitle])
                }
                else {
                    links.append(["url" : url, "title" : ""])
                }
            }

        }
        return links

        
    }
    
    private func fetchLinkTitle(url : String) -> String? {
        let url = NSURL(string: url)
        do {
            let htmlSourceString = try String(contentsOfURL: url!, encoding:  NSASCIIStringEncoding)
            let titleMatch = detectRegexMatches(htmlSourceString, pattern: "<title>(.*?)</title>")
            if titleMatch.count > 0 {
                let titleRange = titleMatch[0].range
                let title =  htmlSourceString.substringWithRange(htmlSourceString.rangeFromNSRange(NSMakeRange(titleRange.location + "<title>".characters.count, titleRange.length - "</title>".characters.count - "<title>".characters.count ))!)
                return title
            }
            else {
                return nil
            }
        } catch let error as NSError {
            print("Error: \(error)")
        }
        return nil
    }
    
    
    
    private func detectRegexMatches(message : String, pattern : String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matchesInString(message, options: [], range: NSMakeRange(0, message.characters.count))
        return matches
    }
    
    
    
    
    
}


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
}