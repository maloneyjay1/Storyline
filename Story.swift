//
//  Story.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.


//removed entries as story prop, will link in fire base as story parent childByAppendingPath with relevant eid
import Foundation
import UIKit

struct Story: Equatable, FirebaseType {
    
    private let UIDKey = "uid"
    private let URLKey = "url"
    private let IDKey = "id"
    private let DateCreatedKey = "dateCreated"
    private let StoryPromptKey = "storyPrompt"
    private let SIDKey = "sid"
    
    let uid: String?
    var dateCreated: NSDate
    let sid: String?
    var storyPrompt: String
    
    init(uid: String, dateCreated: NSDate, sid: String, storyPrompt: String) {
        self.dateCreated = dateCreated
        self.sid = sid
        self.uid = uid
        self.storyPrompt = storyPrompt
    }
    
    
    //MARK: FirebaseType
    
    var endpoint: String = "story"
    
    var jsonValue: [String: AnyObject] {
        
        let json: [String: AnyObject] = [DateCreatedKey:self.dateCreated, UIDKey: self.uid!, SIDKey:self.sid!, StoryPromptKey: self.storyPrompt]
        
        return json
    }
    
    init?(json: [String: AnyObject], uid: String) {
        
        guard let dateCreatedString = json[DateCreatedKey] as? String,
            let sid = json[SIDKey] as? String,
            let uid = json[UIDKey] as? String,
            let storyPrompt = json[StoryPromptKey] as? String
            
            else {
                
                self.uid = UserController.sharedController.currentUser.uid
                self.dateCreated = NSDate()
                self.sid = ""
                self.storyPrompt = ""
                
                return nil
                
        }
        
        self.storyPrompt = storyPrompt
        self.sid = sid
        self.uid = uid
        self.dateCreated = NSDate()
        let dateFormatter = NSDateFormatter()
        let date = dateFormatter.dateFromString(dateCreatedString)
        if let nsDate = date {
            self.dateCreated = nsDate
        }
    }
    
    mutating func dictionaryOfStory() -> [String:AnyObject] {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let dateString = dateFormatter.stringFromDate(date)
        return [StoryPromptKey: self.storyPrompt,
            //            EntriesKey: self.entries,
            UIDKey: self.uid!,
            SIDKey: self.sid!,
            DateCreatedKey: dateString,
            
        ]
    }
}


func ==(lhs:Story, rhs:Story) -> Bool {
    
    return (lhs.sid == rhs.sid)
    
}



