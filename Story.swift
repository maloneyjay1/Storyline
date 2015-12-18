//
//  Story.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.


import Foundation

struct Story: Equatable, FirebaseType {

    private let URLKey = "url"
    private let IDKey = "id"
    private let EntriesKey = "entries"
    private let DateCreatedKey = "dateCreated"
    private let StoryPromptKey = "storyPrompt"
    private let UIDKey = "uid"
    
    var entries: [[String:AnyObject]]
    let dateCreated: NSDate
    var uid: String?
    var storyPrompt: String
    
    init(entries: [[String:AnyObject]], dateCreated: NSDate, uid: String, storyPrompt: String) {
    
        self.entries = entries
        self.dateCreated = dateCreated
        self.uid = uid
        self.storyPrompt = storyPrompt
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "story"
    
    var jsonValue: [String: AnyObject] {
        let dateCreatedString = String(dateCreated)
        let json: [String: AnyObject] = [DateCreatedKey:dateCreatedString, UIDKey:uid!, EntriesKey: entries, StoryPromptKey: storyPrompt]
                return json
    }
    
    init?(json: [String: AnyObject], uid: String) {
        
        guard let uid = json[UIDKey] as? String else {
            
            self.uid = ""

            return nil
        }
        
        if let entries = json[EntriesKey] as? [[String:AnyObject]] {
            self.entries = entries
        } else{
            print("ERROR no [String] in json[EntriesKey]")
        }
        
        if let dateAsString = json[DateCreatedKey] as? String {
            
            let dateFormatter = NSDateFormatter()
            let date = dateFormatter.dateFromString(dateAsString)
            if let nsDate = date {
                self.dateCreated = nsDate
            }
        }
        
        if let storyPrompt = json[StoryPromptKey] as? String {
            
            self.storyPrompt = storyPrompt
            return nil
        }
        
        self.uid = uid
        return nil

    }
}

func ==(lhs:Story, rhs:Story) -> Bool {
    
    return (lhs.uid == rhs.uid)
}


