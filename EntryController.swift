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
    
    static let sharedController = EntryController()
    
    var userEntry: Entry! {
        
        get {
            guard let uid = FirebaseController.base.authData?.uid, let entryDictionary = NSUserDefaults.standardUserDefaults().valueForKey(entryKey) as? [String: AnyObject] else{return nil}
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
    
    static func createEntry(uid:String = UserController.sharedController.currentUser.uid, name: String = UserController.sharedController.currentUser.name!, text: String?, dateCreated: NSDate, completion: (success: Bool, eid: String, newEntry: Entry) -> Void) {
        
        
        let allEntriesRef = FirebaseController.base.childByAppendingPath("/entries/")
        //because this is not a user creation, i manually create the parent firebase id
        let newEntryRef = allEntriesRef.childByAutoId()
        let eid = newEntryRef.key
        
        
        var newEntry = Entry(uid: uid, eid: eid, name: name, text: text, dateCreated: dateCreated , likes: [])
        let entryJson = newEntry.dictionaryOfEntry()
        
        newEntryRef.setValue(entryJson, withCompletionBlock: { (error, Firebase) -> Void in
            
            if error != nil {
                print(error)
            } else {
                print(Firebase)
            }
        })

        completion(success: true, eid: eid, newEntry: newEntry)
        //will return success bool, actual entry parent reference, and the actual model object
        
    }
    
    
    
    static func entryFromIdentifier(user: User, uid: String, completion: (entry: Entry?) -> Void)
        
    {
        FirebaseController.dataAtEndpoint("entries/\(user.uid)") { (data) -> Void in
            
            if let data = data as? [String: AnyObject] {
                let entry = Entry(json: data, uid: user.uid)
                
                completion(entry: entry)
            } else {
                completion(entry: nil)
            }
        }
    }
    
    static func fetchEntryForUser(user: User, completion: (entries: [Entry]?) -> Void) {
        
        var allEntries: [Entry] = []
        
        let dispatchGroup = dispatch_group_create()
        
        dispatch_group_enter(dispatchGroup)
        
        entriesForUser(UserController.sharedController.currentUser.name!, completion:
            { (entries) -> Void in
                
                if let entries = entries {
                    allEntries += entries
                }
                
                dispatch_group_leave(dispatchGroup)
        })
        
        
        entriesForUser(user.name!, completion: { (entries) -> Void in
            
            if let entries = entries {
                allEntries += entries
            }
            
            dispatch_group_leave(dispatchGroup)
        })
        
        
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), { () -> Void in
            
            let orderedEntries = orderEntries(allEntries)
            
            completion(entries: orderedEntries)
        })
        
    }
    
    
    static func appendEntryToMainStory(var entry:Entry, completion: (entry: Entry?) -> Void) {
        
        StoryController.sharedController.currentStory.entries.append(entry.dictionaryOfEntry())
        StoryController.sharedController.currentStory.save()
        completion(entry:entry)
        
    }
    
    
    static func removeEntryFromMainStory(entry:Entry, completion: (success: Bool) -> Void) {
        
        entry.delete()
        StoryController.sharedController.currentStory.save()
        completion(success: true)
        
    }
    
    
    static func entriesForUser(name: String, completion: (entries: [Entry]?) -> Void) {
        FirebaseController.base.childByAppendingPath("entries").queryOrderedByChild("name").queryEqualToValue(name).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let entryDictionaries = snapshot.value as? [String: AnyObject] {
                
                let entries = entryDictionaries.flatMap({Entry(json: $0.1 as! [String : AnyObject], uid: $0.0)})
                
                let orderedEntries = orderEntries(entries)
                
                completion(entries: orderedEntries)
                
            } else {
                
                completion(entries: nil)
            }
        })
    }
    
    
    static func deleteEntry(entry: Entry, completion: (success: Bool) -> Void) {
        
        entry.delete()
        
        completion(success: true)
    }
    
    
    static func saveEntry(var entry: Entry, completion: (success: Bool) -> Void) {
        
        entry.save()
        
        completion(success: true)
    }
    
    
    static func addLikeToEntry(var entry: Entry, completion: (success: Bool, entry: Entry?) -> Void) {
        
        let entryID = entry.uid
        entry.save()
        let likesRef = FirebaseController.base.childByAppendingPath("/likes/")
        let newLikeRef = likesRef.childByAutoId()
        let likesRefIdentifier = newLikeRef.key
        
        //name is name of current user, or "liker", entryIdentifier is the person who wrote the Entry, and uid is the Firebase-generated uid for the brand new Like itself.
        let like = Like(name: UserController.sharedController.currentUser.name!, entryIdentifier: entryID, uid: likesRefIdentifier)
        
        let likeJson = like.dictionaryOfLike()
        FirebaseController.base.childByAppendingPath("/likes/\(likesRefIdentifier)").updateChildValues(likeJson)
        let user = UserController.sharedController.currentUser
        EntryController.entryFromIdentifier(user, uid: entry.uid, completion: { (entry) -> Void in
            completion(success: true, entry: entry)
        })
        
    }
    
    
    static func deleteLike(like: Like, completion: (success: Bool, entry: Entry?) -> Void) {
        
        like.delete()
        let user = UserController.sharedController.currentUser
        EntryController.entryFromIdentifier(user, uid: like.uid, completion: { (entry) -> Void in
            completion(success: true, entry: entry)
        })
    }
    
    
    static func orderEntries(entries: [Entry]) -> [Entry] {
        
        //         sorts posts chronologically using Firebase identifiers
        return entries.sort({$0.0.uid > $0.1.uid})
    }
    
    
    //    static func mockEntries() -> [Entry] {
    //
    ////        let like1 = Like(name: "darth", entryIdentifier: "1234", identifier: "1243")
    ////        let like2 = Like(name: "kenobi", entryIdentifier: "986", identifier: "9783")
    ////        let like3 = Like(name: "luke", entryIdentifier: "78393", identifier: "927")
    //
    //        let entry1 = Entry(identifier: "145", name: "Jay", postedInMain: true, text: "This is a sweet entry", dateCreated: NSDate(), likes: ["like1","like2","like3"])
    //
    //        return [entry1]
    //        
    //    }
    
    
}

