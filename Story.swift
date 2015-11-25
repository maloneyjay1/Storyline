//
//  Story.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation

struct Story: Equatable, FirebaseType {

    private let URLKey = "url"
    private let IDKey = "id"
    private let EntriesKey = "entries"
    private let DateCreatedKey = "dateCreated"
    private let identiferKey = "identifier"
    
    let entries: [Entry]
    let dateCreated: Double?
    var identifier: String?
    
    init(entries: [Entry] = [], dateCreated: Double? = nil, identifier: String? = nil) {
        

        self.entries = entries
        self.dateCreated = dateCreated
        self.identifier = identifier
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "story"
    
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [EntriesKey: AnyObject] 
        
        if let dateCreated = self.dateCreated {
            json.updateValue(dateCreated, forKey: DateCreatedKey)
        }

        return json
    }
    
    init?(json: [String: AnyObject], identifier: String?) {
        
        guard let identifier = json[identiferKey] as? String else {
            
            self.identifier = ""

            return nil
        }
        
        self.entries = (json[EntriesKey] as? [Entry])!
        self.dateCreated = json[DateCreatedKey] as? Double
        self.identifier = identifier

    }
}

func ==(lhs:Story, rhs:Story) -> Bool {
    
    return (lhs.identifier == rhs.identifier)
}


