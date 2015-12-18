//
//  Like.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.


import Foundation

struct Like: Equatable, FirebaseType {
    
    static let UserKey = "username"
    static let EntryKey = "entry"
    static let NameKey = "name"
    static let EntryIdentifierKey = "entryIdentifier"
    static let UIDKey = "uid"
    
    let name: String
    let entryIdentifier: String
    var uid: String?
    
    init(name: String, entryIdentifier: String, uid: String) {
        
        self.name = name
        self.entryIdentifier = entryIdentifier
        self.uid = uid
    }
    
    // MARK: FirebaseType
    
    var endpoint: String {
        
        return "entries/\(self.entryIdentifier)/likes/"
        //entryIdentifier is entry.eid
        
    }
    
    var jsonValue: [String: AnyObject] {
        
        return [Like.UserKey: self.name, Like.EntryKey: self.entryIdentifier]
    }
    
    init?(json: [String: AnyObject], uid: String = "") {
        
        guard let entryIdentifier = json[Like.EntryKey] as? String,
            let name = json[Like.UserKey] as? String,
            let uid = json[Like.UIDKey] as? String else { return nil }
        
        self.init(name: name, entryIdentifier: entryIdentifier, uid: uid)

    }
    
    func dictionaryOfLike() -> [String:AnyObject] {
        
        return [Like.NameKey: self.name,
            Like.EntryIdentifierKey: self.entryIdentifier,
            Like.UIDKey: self.uid!
        ]
    }
}

func ==(lhs: Like, rhs: Like) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.uid == rhs.uid)
}