//
//  User.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation

struct User: Equatable, FirebaseType {
    
    private let UIDKey = "uid"
    private let NameKey = "name"
    private let EmailKey = "email"
    private let PasswordKey = "password"
    private let URLKey = "url"
    private let IDKey = "id"
    private let identiferKey = "identifier"
    
    let id: String
    let name: String?
    var email: String?
    var password: String?
    var identifier: String
    
    init(id: String, uid: String, name: String? = nil, email: String? = nil, password: String? = nil) {
        
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.identifier = uid
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "users"
    
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [:]
        
        if let name = self.name {
            json.updateValue(name, forKey: NameKey)
        }
        
        if let email = self.email {
            json.updateValue(email, forKey: EmailKey)
        }
        
        if let password = self.password {
            json.updateValue(password, forKey: PasswordKey)
        }
        
        return json
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        
        guard let id = json[IDKey] as? String else {
            
            self.id = ""
            
            return nil
        }
        
        self.id = id
        self.name = json[NameKey] as? String
        self.email = json[EmailKey] as? String
        self.password = json[PasswordKey] as? String
        self.identifier = identifier
        
    }
    
    func dictionaryOfUser() -> [String:AnyObject] {
        
        return [IDKey: self.id,
            NameKey: self.name!,
            EmailKey: self.email!,
            PasswordKey: self.password!,
            identiferKey: self.identifier,

        ]
    }
}

func ==(lhs:User, rhs:User) -> Bool {
    
    return (lhs.id == rhs.id) && (lhs.identifier == rhs.identifier)
}