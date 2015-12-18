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
    private let EmailKey = "email"
    private let NameKey = "name"
    private let UIDKey = "uid"
    private let IDKey = "id"
    private let PasswordKey = "password"
    private let URLKey = "url"
    
    static let sharedController = UserController()
    
    var currentUser: User! {
        
        get {
            
            guard let uid = FirebaseController.base.authData?.uid,
                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(UserKey) as? [String: AnyObject] else{return nil}
            let user = User(json: userDictionary, uid: uid)
            return user
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
    
    
    
    //test successful
    static func userForIdentifier(uid: String, completion: (user: User?) -> Void) {
        
        FirebaseController.dataAtEndpoint("users/\(uid)") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, uid: uid)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    
    
    //successful test
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        
        FirebaseController.dataAtEndpoint("users") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                
                let users = json.flatMap({User(json: $0.1 as! [String : AnyObject], uid: $0.0)})
                
                completion(users: users)
                
            }
        }
    }
    

    
    //successful test
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

    
    //successful test
    static func createFirebaseUser(email: String, name: String, password: String,completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.createUser(email, password: password) { (error, newlyCreatedUser) -> Void in
            if error != nil {
                print(error.localizedDescription)
                completion(success: false, user: nil)
                
            } else {
                if let uid = newlyCreatedUser["uid"] as? String {
                    
                    let allUsersRef = FirebaseController.base.childByAppendingPath("/users/")
                    let newUserRef = allUsersRef.childByAppendingPath(uid)
                    
                    let newUser = User(uid: uid, name: name, email: email, password: password)
                    let userJson = newUser.dictionaryOfUser()
                    
                    newUserRef.setValue(userJson, withCompletionBlock: { (error, Firebase) -> Void in
                        
                        authenticateUser(email, password: password, completion: { (success, user) -> Void in
                            completion(success: true, user: newUser)
                            
                        })
                    })
                }
            }
        }
    }
    

    //testing
    static func updateUser(user: User, name: String?, completion: (success: Bool, user: User?) -> Void) {
        
        let NameKey = "name"

        let userURLRef = FirebaseController.base.childByAppendingPath("users/\(user.uid)/")
        
     
        if let name = name {
            userURLRef.updateChildValues([NameKey:name])
        } else {
            print("nil")
        }
        
        completion(success: true, user: user)
        
    }
    
    
    
    static func logoutCurrentUser() {
        
        FirebaseController.base.unauth()
        sharedController.currentUser = nil
        
    }
}