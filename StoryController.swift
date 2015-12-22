//
//  StoryController.swift
//  storyLine
//
//  Created by Jay Maloney on 11/25/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation
import UIKit


class StoryController {
    
    private let StoryKey = "story"
    private let storiesKey = "stories"
    
    static let sharedInstance = StoryController()
    
    var userStory: Story! {
        
        get {
            
            guard let uid = FirebaseController.base.authData?.uid, let storyDictionary = NSUserDefaults.standardUserDefaults().valueForKey(StoryKey) as? [String: AnyObject] else {return nil}
            let story = Story(json: storyDictionary, uid: uid)
            return story
            
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
    
    
    
    static func createStory(uid:String = UserController.sharedController.currentUser.uid!, dateCreated: NSDate, storyPrompt: String, completion: (success: Bool, newStory: Story, dateCreated: NSDate, sid: String) -> Void) {
        
        let allStoriesRef = FirebaseController.base.childByAppendingPath("stories")
        let newStoryRef = allStoriesRef.childByAutoId()
        let sid = newStoryRef.key
        
        var newStory = Story(uid: UserController.sharedController.currentUser.uid!, dateCreated: dateCreated, sid: sid, storyPrompt: storyPrompt)
        let storyJson = newStory.dictionaryOfStory()
        
        newStoryRef.setValue(storyJson, withCompletionBlock: { (error, Firebase) -> Void in
            
            if error != nil {
                print(error)
            } else {
                print(Firebase)
            }
        })
        
        completion(success: true, newStory: newStory, dateCreated: dateCreated, sid: sid)
        
    }
    
    
    
    static func storyFromIdentifier(user: User, uid: String, completion: (story: Story?) -> Void) {
        
        FirebaseController.dataAtEndpoint("stories.childByAutoId().key") { (data) -> Void in
            
            if let data = data as? [String: AnyObject] {
                
                let story = Story(json: data, uid: user.uid!)
                
                completion(story: story)
            } else {
                completion(story: nil)
            }
        }
    }
    
    
    
    static func fetchstoriesForUser(user: User, completion: (stories: [Story]?) -> Void) {
        
        var allStories: [Story] = []
        
        storiesForUser(user.uid!, completion: { (stories) -> Void in
            
            if let stories = stories {
                allStories = stories
                print("All stories count: \(allStories.count)")
                let orderedStories = orderStories(allStories)
                completion(stories: orderedStories)
            }
        })
    }
    
    
    
    static func storiesForUser(uid: String?, completion: (stories: [Story]?) -> Void) {
        
        let currentUserUID = UserController.sharedController.currentUser.uid
        let storyEnd = "\(FirebaseController.base.childByAppendingPath("stories").childByAppendingPath("uid").queryEqualToValue(currentUserUID))"
        
        FirebaseController.base.childByAppendingPath("stories").queryOrderedByChild(storyEnd).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if let storyDictionaries = snapshot.value as? [String:AnyObject] {
                
                let stories = storyDictionaries.flatMap({Story(json: $0.1 as! [String: AnyObject], uid: $0.0)})
                let orderedStories = orderStories(stories)
                
                completion(stories: orderedStories)
                
            } else {
                
            }
            completion(stories:nil)
        })
    }
    
    
    static func deleteStory(story: Story, completion: (success: Bool) -> Void) {
        
        story.delete()
        
        completion(success: true)
    }
    
    
    static func saveStory(var story: Story, completion: (success: Bool) -> Void) {
        
        story.save()
        
        completion(success: true)
    }
    
    
    // NEED currentEntriesForStory
    
    
    //    static func fetchUsersForStory(story: Story, completion: (users: [User]?) -> Void) {
    //
    //        var allUsers: [User] = []
    //
    //        let dispatchGroup = dispatch_group_create()
    //
    //        dispatch_group_enter(dispatchGroup)
    //
    //        usersForStory(StoryController.sharedController.currentStory.uid!, completion: {
    //            (users) -> Void in
    //
    //            if let users = users {
    //                allUsers += users
    //            }
    //
    //            dispatch_group_leave(dispatchGroup)
    //        })
    //
    //        dispatch_group_enter(dispatchGroup)
    //
    //        usersForStory(story.uid!, completion: { (users) -> Void in
    //
    //            if let users = users {
    //                allUsers += users
    //            }
    //
    //            dispatch_group_leave(dispatchGroup)
    //        })
    //
    //        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue()) { () -> Void in
    //
    //            let orderedUsers = orderUsers(allUsers)
    //
    //            completion(users: orderedUsers)
    //        }
    //    }
    
    
    
    
    static func orderStories(stories: [Story]) -> [Story] {
        
        return stories.sort({$0.0.uid > $0.1.uid})
    }
    
    
}
