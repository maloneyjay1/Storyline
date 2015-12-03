//
//  StoryController.swift
//  storyLine
//
//  Created by Jay Maloney on 11/25/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation
import UIKit

//remove entry from story,
//update story

class StoryController {
    
    private let StoryKey = "story"
    
    static let sharedController = StoryController()
    
    var currentStory: Story! {
        get {
            
            guard let storyDictionary = NSUserDefaults.standardUserDefaults().valueForKey(StoryKey) as? [String: AnyObject] else {
                return nil
            }
            
            return Story(json: storyDictionary, identifier: StoryController.sharedController.currentStory.identifier)
        }
        set {
            
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: StoryKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(StoryKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    static func orderUsers(users: [User]) -> [User] {
        
        // sorts posts chronologically using Firebase identifiers
        return users.sort({$0.0.name > $0.1.name})
    }
    
    static func usersForStory(identifier: String, completion: (users: [User]?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("users").queryOrderedByChild("identifier").queryEqualToValue(identifier).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let userDictionaries = snapshot.value as? [String: AnyObject] {
                
                let users = userDictionaries.flatMap({User(json: $0.1 as! [String:AnyObject], identifier: $0.0)})
                
                let orderedUsers = orderUsers(users)
                
                completion(users: orderedUsers)
            }
        })
    }
    

    static func addStory(identifier: String, entries: [[String:AnyObject]], storydateCreated: NSDate, storyPrompt: String, completion: (story:Story?) -> Void) {
        
        var story = Story(entries: entries, dateCreated: NSDate(), identifier: NSUUID().UUIDString, storyPrompt: "")
        
        story.save()
        completion(story: story)
        
    }
    
    
    //NEED UPDATE METHOD
    //static func updateMainStoryEntry
    
    
    static func deleteStory(story: Story, completion: (success: Bool) -> Void) {
        
        story.delete()
        
        completion(success: true)
    }
    
    
    static func saveStory(var story: Story, completion: (success: Bool) -> Void) {
        
        story.save()
        
        completion(success: true)
    }

    
    static func fetchUsersForStory(story: Story, completion: (users: [User]?) -> Void) {
        
        var allUsers: [User] = []
        
        let dispatchGroup = dispatch_group_create()
        
        dispatch_group_enter(dispatchGroup)
        
        usersForStory(StoryController.sharedController.currentStory.identifier, completion: {
            (users) -> Void in
            
            if let users = users {
                allUsers += users
            }
            
            dispatch_group_leave(dispatchGroup)
        })
        
        dispatch_group_enter(dispatchGroup)
        
        usersForStory(story.identifier, completion: { (users) -> Void in
            
            if let users = users {
                allUsers += users
            }
            
            dispatch_group_leave(dispatchGroup)
        })
        
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue()) { () -> Void in
            
            let orderedUsers = orderUsers(allUsers)
            
            completion(users: orderedUsers)
        }
    }
    
}
