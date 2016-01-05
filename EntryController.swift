//
//  EntryController.swift
//  storyLine
//
//  Created by Jay Maloney on 11/25/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//


import Foundation
import UIKit


class EntryController {
    
    private let entryKey = "entry"
    private let entriesKey = "entries"
    
    static let sharedController = EntryController()
    
    var userEntry: Entry! {
        
        get {
            guard let uid = FirebaseController.base.authData?.uid, let entryDictionary = NSUserDefaults.standardUserDefaults().valueForKey(entryKey) as? [String: AnyObject] else {return nil}
            let entry = Entry(json: entryDictionary, uid: uid)
            return entry
            
        }
        
        set {
            
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: entryKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(entryKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    //    var entries = [Entry]()
    
    static func createEntry(uid:String = UserController.sharedController.currentUser.uid!, name: String = UserController.sharedController.currentUser.name!, text: String?, dateCreated: NSDate, completion: (success: Bool, dateCreated: NSDate, eid: String, newEntry: Entry) -> Void) {
        
        let allEntriesRef = FirebaseController.base.childByAppendingPath("entries")
        
        let newEntryRef = allEntriesRef.childByAutoId()
        let eid = newEntryRef.key
        
        var newEntry = Entry(uid: UserController.sharedController.currentUser.uid!, eid: eid, name: name, text: text, dateCreated: dateCreated)
        let entryJson = newEntry.dictionaryOfEntry()
        
        newEntryRef.setValue(entryJson, withCompletionBlock: { (error, Firebase) -> Void in
            
            if error != nil {
                print(error)
            } else {
                print(Firebase)
            }
        })
        
        completion(success: true, dateCreated: dateCreated, eid: eid, newEntry: newEntry)
    }
    
    
    
    
    static func entryFromIdentifier(user: User, uid: String, completion: (entry: Entry?) -> Void)
        
    {
        FirebaseController.dataAtEndpoint("entries.childByAutoId().key") { (data) -> Void in
            
            if let data = data as? [String: AnyObject] {
                let entry = Entry(json: data, uid: user.uid!)
                
                completion(entry: entry)
            } else {
                completion(entry: nil)
            }
        }
    }
    
    
    
    static func fetchEntriesForUser(user: User, completion: (entries: [Entry]?) -> Void) {
        
        var allEntries: [Entry] = []
        
        entriesForUser(user.uid!, completion: { (entries) -> Void in
            
            if let entries = entries {
                allEntries = entries
                print("ALL ENTRIES COUNT: \(allEntries.count)")
                let orderedEntries = orderEntries(allEntries)
                completion(entries: orderedEntries)
            }
        })
    }
    
    
    
    
    static func entriesForUser(uid: String?, completion: (entries: [Entry]?) -> Void) {
        
        let currentUserUID = UserController.sharedController.currentUser.uid
        let entryEnd = "\(FirebaseController.base.childByAppendingPath("entries").childByAppendingPath("uid").queryEqualToValue(currentUserUID))"
        
        FirebaseController.base.childByAppendingPath("entries").queryOrderedByChild(entryEnd).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let entryDictionaries = snapshot.value as? [String: AnyObject] {
                
                let entries = entryDictionaries.flatMap({Entry(json: $0.1 as! [String : AnyObject], uid: $0.0)})
                let orderedEntries = orderEntries(entries)
                
                completion(entries: orderedEntries)
                
            } else {
                
                completion(entries: nil)
            }
        })
    }
    
    
    
    
    static func returnCurrentStories(completion: (stories: [Story]?) -> Void) {
        
        //        let storyEnd = "\(FirebaseController.base.childByAppendingPath("stories"))"
        
        FirebaseController.base.childByAppendingPath("stories").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if let storyDictionaries = snapshot.value as? [String:AnyObject] {
                
                let stories = storyDictionaries.flatMap({Story(json: $0.1 as! [String:AnyObject], uid: (UserController.sharedController.currentUser?.uid)! ) } )
                
                completion(stories: stories)
            }
            
        })
    }
    
    
    
    static func fetchStories(completion: (stories:[Story]?) -> Void) {
        
        var allStories: [Story] = []
        
        returnCurrentStories { (stories) -> Void in
            
            if let stories = stories {
                allStories = stories
                print("ALL STORIES COUNT: \(allStories.count)")
                completion(stories: allStories)
            }
        }
    }
    
    
    
    
    //    static func returnCurrentStories(completion: (success:Bool) -> Void) {
    //
    //        FirebaseController.base.childByAppendingPath("stories").observeSingleEventOfType(.Value, withBlock: { snapshot in
    //
    //            var storyArray = [[String:AnyObject]]()
    //
    //            if let storyDictionaries = snapshot.value as? [String: [String : AnyObject]] {
    //                storyDictionaries.forEach({ (storyDictionary) -> () in
    //
    //                    let storyJson = storyDictionary.1
    //                    storyArray.append(storyJson)
    //                })
    //
    //                let storyCount = storyArray.count
    //                print("\(storyCount)")
    //
    //                completion(success: true)
    //            } else {
    //
    //                print("Error finding stories.")
    //                completion(success:false)
    //            }
    //        })
    //    }
    
    
    
    static func likesForEntry(entry:Entry, completion: (success:Bool) -> Void) {
        
        let eid = entry.eid
        FirebaseController.base.childByAppendingPath("likes").childByAppendingPath(eid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var likeArray = [[String: AnyObject]]()
            //            var likeArray = [Like]()
            
            if let likeDictionaries = snapshot.value as? [String: [String : AnyObject]] {
                
                likeDictionaries.forEach({ (likeDictionary) -> () in
                    
                    let likeJson = likeDictionary.1
                    likeArray.append(likeJson)
                })
                
                let likeCount = likeArray.count
                print("\(likeCount)")
                
                completion(success: true)
                
            } else {
                
                print("Error finding likes for \(eid)")
                completion(success: false)
            }
        })
    }
    
    
    
    static func userForLikedEntry(entry:Entry, completion: (success: Bool) -> Void) {
        
        let eid = entry.eid
        
        FirebaseController.base.childByAppendingPath("likes").childByAppendingPath(eid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let likeDictionaries = snapshot.value as? [String: [String : AnyObject]] {
                
                likeDictionaries.forEach({ (likeDictionary) -> () in
                    
                    let likeJson = likeDictionary.1
                    let likedUID = likeJson["uid"]
                    print("\(likedUID)")
                    
                })
                
                completion(success: true)
                
            } else {
                print("Error finding UID for liked entry.")
                completion(success: false)
            }
        })
    }
    
    
    
    static func entryOfTheDay(entry:Entry, completion: (highest: String?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("likes").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let likes = snapshot.value as? [String:AnyObject] {
                
                var highestEntryId = ""
                
                var highestCount = -1
                
                var likeCountDictionary = [String : Int]()
                
                for (entryId, dictionaryOfLikesOfEntry) in likes {
                    
                    likeCountDictionary[entryId] = dictionaryOfLikesOfEntry.allKeys.count
                    
                    if dictionaryOfLikesOfEntry.allKeys.count > highestCount {
                        
                        highestEntryId = entryId
                        highestCount = dictionaryOfLikesOfEntry.allKeys.count
                    }
                }
                
                print(likeCountDictionary)
                completion(highest: highestEntryId)
            }
        })
    }
    
    
    
    
    static  func addEntryToStory(var entry: Entry, story: Story, completion: (success: Bool) -> Void) {
        
        if let entryIdentifier = entry.eid {
            
            if let storyIdentifier = story.sid {
                
                let endPoint = FirebaseController.base.childByAppendingPath("stories").childByAppendingPath(storyIdentifier)
                
                let newStoryEntryRef = endPoint.childByAppendingPath(entryIdentifier)
                
                let entryJson = entry.dictionaryOfEntry()
                
                newStoryEntryRef.updateChildValues(entryJson, withCompletionBlock: { (error, Firebase) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(success: false)
                    } else {
                        completion(success: true)
                        print("Entry added to story.")
                    }
                })
                
            } else {
                print("No SID!")
            }
            
        } else {
            print("No EID!")
        }
        
    }
    
    
    
    static func addLikeToEntry(entry: Entry, completion: (success: Bool) -> Void) {
        
        if let entryIdentifier = entry.eid {
            
            let endPoint = FirebaseController.base.childByAppendingPath("likes").childByAppendingPath(entryIdentifier)
            
            let newLikeRef = endPoint.childByAutoId()
            
            let like = Like(name: UserController.sharedController.currentUser.name!, entryIdentifier: entryIdentifier, uid: UserController.sharedController.currentUser.uid!)
            
            let likeJson = like.dictionaryOfLike()
            
            newLikeRef.updateChildValues(likeJson, withCompletionBlock: { (error, Firebase) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    completion(success: false)
                } else {
                    completion(success: true)
                }
            })
            
        } else {
            print("No EID!")
        }
    }
    
    
    
    
    static func deleteLike(like: Like, completion: (success: Bool) -> Void) {
        
        like.delete()
        completion(success: true)
    }
    
    
    //    static func appendEntryToMainStory(var entry:Entry, completion: (entry: Entry?) -> Void) {
    //
    //
    //        EntryController.sharedController.userEntry.entries.append(entry.dictionaryOfEntry())
    //        EntryController.sharedController.userEntry.save()
    //        completion(entry:entry)
    //
    //    }
    
    
    
    static func removeEntryFromMainStory(entry:Entry, completion: (success: Bool) -> Void) {
        
        entry.delete()
        EntryController.sharedController.userEntry.save()
        completion(success: true)
        
    }
    
    
    static func deleteEntry(entry: Entry, completion: (success: Bool) -> Void) {
        
        entry.delete()
        completion(success: true)
    }
    
    
    static func saveEntry(var entry: Entry, completion: (success: Bool) -> Void) {
        
        entry.save()
        completion(success: true)
    }
    
    
    static func orderEntries(entries: [Entry]) -> [Entry] {
        
        return entries.sort({$0.0.uid > $0.1.uid})
    }
}
