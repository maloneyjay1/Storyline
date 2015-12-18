//
//  FirebaseController.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let base = Firebase(url: "https://storylineapp.firebaseio.com/")
    
    static func dataAtEndpoint(endpoint: String, completion: (data:AnyObject?) -> Void) {
        
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        
        baseForEndpoint.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
    static func observeDataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        
        let baseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        
        baseForEndpoint.observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
}

protocol FirebaseType {
    
    var uid: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    

    init?(json: [String: AnyObject], uid: String)

    mutating func save()
    func delete()
}

extension FirebaseType {
    
//    mutating func save() {
//        
//        var endpointBase: Firebase
//        
//        endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAutoId()
//        self.uid = endpointBase.key
//        
//        endpointBase.updateChildValues(self.jsonValue)
//        
//    }
    
    mutating func save() {
        
        var endpointBase: Firebase
        
        if let childID = self.uid {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(childID)
        } else {
            endpointBase = FirebaseController.base.childByAppendingPath(endpoint).childByAutoId()
            self.uid = endpointBase.key
        }
        
        endpointBase.updateChildValues(self.jsonValue)
        
    }
    
    
    func delete() {
        
        let endpointBase: Firebase = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(self.uid)
        
        endpointBase.removeValue()
    }
    
    
    func syncFromFirebase() {
        let user = UserController.sharedController.currentUser
        FirebaseController.dataAtEndpoint("users/\(user.uid)/", completion: { (data) -> Void in
            if let jsonDic = data as? [String:AnyObject] {
                
                let updatedUser = User(json: jsonDic, uid: user!.uid!)
                UserController.sharedController.currentUser = updatedUser
            }
            
        })
    }
    
    
    func update() {
        
        let user = UserController.sharedController.currentUser
        UserController.updateUser(user, name: user.name) { (success, user) -> Void in
            if success == true {
                // completion(success: true, user: user)
                
                FirebaseController.dataAtEndpoint("users/\(user!.uid)/", completion: { (data) -> Void in
                    if let jsonDic = data as? [String:AnyObject] {
                        
                        let updatedUser = User(json: jsonDic, uid: user!.uid!)
                        UserController.sharedController.currentUser = updatedUser
                    }
                    
                })
                
                print(UserController.sharedController.currentUser.name)
            } else {
                print("no user")
            }
            
            let user = UserController.sharedController.currentUser
            FirebaseController.dataAtEndpoint("users/\(user.uid)/", completion: { (data) -> Void in
                if let jsonDic = data as? [String:AnyObject] {
                    
                    let updatedUser = User(json: jsonDic, uid: user!.uid!)
                    UserController.sharedController.currentUser = updatedUser
                    
                }
            })
        }
    }
}

