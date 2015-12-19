//
//  StoryController.swift
//  storyLine
//
//  Created by Jay Maloney on 11/25/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation
import UIKit



//needs function to append entry with most likes in likes array at end of 24 hour period, and delete the rest of the entries.
    //this function also needs tie breaker logic.

// Get likes for entries in entry array, loop through and compare number of likes of paired entries, and append any tied objects to a tie array.  if no tie, directly append winning entry to story property of entries.

class StoryController {
    
    private let StoryKey = "story"
    static let sharedController = StoryController()
    
    var currentStory: Story! {
        
        get {
            
            guard let storyDictionary = NSUserDefaults.standardUserDefaults().valueForKey(StoryKey) as? [String: AnyObject] else {
                return nil
            }
            
            return Story(json: storyDictionary, uid: StoryController.sharedController.currentStory.uid!)
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
    
    
    var entries: [[String:AnyObject]]
    

    var storyPrompt: String
    
    static func createStory(uid:String = UserController.sharedController.currentUser.uid!, dateCreated: NSDate, entries: [[String:AnyObject]], storyPrompt: String, completion: (success: Bool, dateCreated: NSDate, sid: String)
    
    
    
    //    //successful
    //    static func createEntry(uid:String = UserController.sharedController.currentUser.uid!, name: String = UserController.sharedController.currentUser.name!, text: String?, dateCreated: NSDate, completion: (success: Bool, dateCreated: NSDate, eid: String, newEntry: Entry) -> Void) {
    //
    //
    //        let allEntriesRef = FirebaseController.base.childByAppendingPath("entries")
    //
    //        let newEntryRef = allEntriesRef.childByAutoId()
    //        let eid = newEntryRef.key
    //
    //        var newEntry = Entry(uid: UserController.sharedController.currentUser.uid!, eid: eid, name: name, text: text, dateCreated: dateCreated)
    //        let entryJson = newEntry.dictionaryOfEntry()
    //
    //        newEntryRef.setValue(entryJson, withCompletionBlock: { (error, Firebase) -> Void in
    //
    //            if error != nil {
    //                print(error)
    //            } else {
    //                print(Firebase)
    //            }
    //        })
    //
    //        completion(success: true, dateCreated: dateCreated, eid: eid, newEntry: newEntry)
    //    }
    
    
    static func usersForStory(uid: String, completion: (users: [User]?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("users").queryOrderedByChild("uid").queryEqualToValue(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let userDictionaries = snapshot.value as? [String: AnyObject] {
                
                let users = userDictionaries.flatMap({User(json: $0.1 as! [String:AnyObject], uid: $0.0)})
                
                let orderedUsers = orderUsers(users)
                
                completion(users: orderedUsers)
            }
        })
    }
    

    static func addStory(uid: String, entries: [[String:AnyObject]], storydateCreated: NSDate, storyPrompt: String, completion: (story:Story?) -> Void) {
        
        var story = Story(entries: entries, dateCreated: NSDate(), uid: UserController.sharedController.currentUser.uid!, storyPrompt: "")
        
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
    
    
    // NEED currentEntriesForStory

    
    static func fetchUsersForStory(story: Story, completion: (users: [User]?) -> Void) {
        
        var allUsers: [User] = []
        
        let dispatchGroup = dispatch_group_create()
        
        dispatch_group_enter(dispatchGroup)
        
        usersForStory(StoryController.sharedController.currentStory.uid!, completion: {
            (users) -> Void in
            
            if let users = users {
                allUsers += users
            }
            
            dispatch_group_leave(dispatchGroup)
        })
        
        dispatch_group_enter(dispatchGroup)
        
        usersForStory(story.uid!, completion: { (users) -> Void in
            
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
    
    
    static func orderUsers(users: [User]) -> [User] {
        
        // sorts posts chronologically using Firebase identifiers
        return users.sort({$0.0.name > $0.1.name})
    }
    
}
