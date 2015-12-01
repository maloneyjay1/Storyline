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
    private let identifierKey = "identifier"
    private let StoryPromptKey = "storyPrompt"
    
    
    var entries: [[String:AnyObject]]
    let dateCreated: NSDate
    var identifier: String
    var storyPrompt: String
    
    init(entries: [[String:AnyObject]], dateCreated: NSDate, identifier: String, storyPrompt: String) {
        

        self.entries = entries
        self.dateCreated = dateCreated
        self.identifier = identifier
        self.storyPrompt = storyPrompt
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "story"
    
    var jsonValue: [String: AnyObject] {
        let dateCreatedString = String(dateCreated)
        let json: [String: AnyObject] = [DateCreatedKey:dateCreatedString, identifierKey:identifier, EntriesKey: entries, StoryPromptKey: storyPrompt]
                return json
    }
    
    init?(json: [String: AnyObject], identifier: String?) {
        
        guard let identifier = json[identifierKey] as? String else {
            
            self.identifier = ""

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
        
        self.identifier = identifier
        return nil

    }
}

func ==(lhs:Story, rhs:Story) -> Bool {
    
    return (lhs.identifier == rhs.identifier)
}


