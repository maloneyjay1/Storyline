//
//  Like.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.


import Foundation

struct Like: Equatable, FirebaseType {
    
    private let UserKey = "username"
    private let PostKey = "post"
    
    let name: String
    let entryIdentifier: String
    var identifier: String
    
    init(name: String, entryIdentifier: String, identifier: String? = nil) {
        
        self.name = name
        self.entryIdentifier = entryIdentifier
        self.identifier = identifier!
    }
    
    // MARK: FirebaseType
    
    var endpoint: String {
        
        return "/posts/\(self.entryIdentifier)/likes/"
    }
    
    var jsonValue: [String: AnyObject] {
        
        return [UserKey: self.name, PostKey: self.entryIdentifier]
    }
    
    init?(json: [String: AnyObject], identifier: String?) {
        
        guard let postIdentifier = json[PostKey] as? String,
            let name = json[UserKey] as? String else {
                
                self.identifier = ""
                self.entryIdentifier = ""
                self.name = ""
                
                return nil
        }
        
        self.entryIdentifier = postIdentifier
        self.name = name
        self.identifier = identifier!
    }
}

func ==(lhs: Like, rhs: Like) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.identifier == rhs.identifier)
}