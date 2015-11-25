//
//  UserController.swift
//  storyLine
//
//  Created by Jay Maloney on 11/24/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation

class UserController {
    
    private let UserKey = "user"
    
    static let sharedController = UserController()
    
    var currentUser: User! {
        get {
            
            guard let uid = FirebaseController.base.authData?.uid,
                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(UserKey) as? [String: AnyObject] else {
                    
                    return nil
            }
            
            return User(json: userDictionary, identifier: uid)
        }
        
        set {
            
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: UserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(UserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        
        FirebaseController.dataAtEndpoint("users") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                
                let users = json.flatMap({User(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
                completion(users: users)
                
            }
        }
    }
    
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
            
            if error != nil {
                
                print("Unsuccessful login attempt.")
            } else {
                print("User ID: \(response.uid) authenticated successfully.")
                
                UserController.userForIdentifier(response.uid, completion: { (user) -> Void in
                    
                    if let user = user {
                        
                        sharedController.currentUser = user
                    }
                    
                    completion(success: true, user: user)
                })
            }
        }
    }
    
    static func createUser(email: String, name: String, password: String, url: String?, completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
            
            if let uid = response["uid"] as? String {
                var user = User(id: name, uid: uid, name: url)
                user.save()
                
                authenticateUser(email, password: password, completion: { (success, user) -> Void in
                    completion(success: success, user: user)
                })
            }
        }
        
        completion(success: true, user: mockUsers().first)
    }
    
    static func updateUser(user: User, name: String, url: String?, email: String?, password: String?, completion: (success: Bool, user: User?) -> Void) {
        
        var updatedUser = User(id: user.id, uid: user.identifier!, name: user.name!, email: user.email, password: user.password)
        
        updatedUser.save()
        
        UserController.userForIdentifier(user.identifier!) { (user) -> Void in
            
            if let user = user {
                
                sharedController.currentUser = user
            }
            
            completion(success: true, user: user)
        }
    }
    
    static func logoutCurrentUser() {
        
        FirebaseController.base.unauth()
        
        sharedController.currentUser = nil
    }
    
    static func mockUsers() -> [User] {
        
        let user1 = User(id: "123", uid: "1234", name: "Leeroy Jenkins", email: "leeroy@jenkins.com", password: "password1")
        let user2 = User(id: "456", uid: "987", name: "Darth Vader", email: "vader@empire.gov", password: "darkside")
        
        return [user1, user2]
    }
    
}