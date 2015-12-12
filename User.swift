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

    let name: String?
    var email: String?
    var password: String?
    var uid: String
    
    init(uid: String, name: String? = nil, email: String? = nil, password: String? = nil) {
    
        self.name = name
        self.email = email
        self.password = password
        self.uid = uid
        
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
    
    init?(json: [String: AnyObject], uid: String) {
        
        guard let name = json[NameKey] as? String else {
            
            self.name = json[NameKey] as? String
         
            
            return nil
        }
        
        self.name = name
        self.email = json[EmailKey] as? String
        self.password = json[PasswordKey] as? String
        self.uid = uid
       
 
        
    }
    
    func dictionaryOfUser() -> [String:AnyObject] {
        
        return [NameKey: self.name!,
            EmailKey: self.email!,
            PasswordKey: self.password!,
            UIDKey: self.uid,

        ]
    }
}

func ==(lhs:User, rhs:User) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.uid == rhs.uid)
}