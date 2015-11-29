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
    private let identiferKey = "identifier"
    
    let entries: [String] 
    let dateCreated: NSDate
    var identifier: String
    
    init(entries: [String], dateCreated: NSDate, identifier: String) {
        

        self.entries = entries
        self.dateCreated = dateCreated
        self.identifier = identifier
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "story"
    
    var jsonValue: [String: AnyObject] {
        let dateCreatedString = String(dateCreated)
        let json: [String: AnyObject] = [DateCreatedKey:dateCreatedString, identiferKey:identifier, EntriesKey: entries]
                return json
    }
    
    init?(json: [String: AnyObject], identifier: String?) {
        
        guard let identifier = json[identiferKey] as? String else {
            
            self.identifier = ""

            return nil
        }
        
        if let entries = json[EntriesKey] as? [String] {
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
        
        self.identifier = identifier
        return nil

    }
}

func ==(lhs:Story, rhs:Story) -> Bool {
    
    return (lhs.identifier == rhs.identifier)
}


