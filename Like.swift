//
//  Like.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.


import Foundation

struct Like: Equatable, FirebaseType {
    
    private let UserKey = "username"
    private let EntryKey = "entry"
    private let NameKey = "name"
    private let EntryIdentifierKey = "entryIdentifier"
    private let UIDKey = "uid"
    
    let name: String
    let entryIdentifier: String
    var uid: String
    
    init(name: String, entryIdentifier: String, uid: String) {
        
        self.name = name
        self.entryIdentifier = entryIdentifier
        self.uid = uid
    }
    
    // MARK: FirebaseType
    
    var endpoint: String {
        
        return "/posts/\(self.entryIdentifier)/likes/"
        
    }
    
    var jsonValue: [String: AnyObject] {
        
        return [UserKey: self.name, EntryKey: self.entryIdentifier]
    }
    
    init?(json: [String: AnyObject], uid: String) {
        
        guard let postIdentifier = json[EntryKey] as? String,
            let name = json[UserKey] as? String else {
                
                self.uid = ""
                self.entryIdentifier = ""
                self.name = ""
                
                return nil
        }
        
        self.entryIdentifier = postIdentifier
        self.name = name
        self.uid = uid
    }
    
    func dictionaryOfLike() -> [String:AnyObject] {
        
        return [NameKey: self.name,
            EntryIdentifierKey: self.entryIdentifier,
            UIDKey: self.uid
        ]
    }
}

func ==(lhs: Like, rhs: Like) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.uid == rhs.uid)
}