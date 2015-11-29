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
        
        
            dispatch_group_enter(dispatchGroup)
            
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
    
    static func addEntry(identifier: String?, name: String = UserController.sharedController.currentUser.name!, postedInMain: Bool, text: String?, dateCreated: NSDate, completion: (entry: Entry?) -> Void) {
        
        if let identifier = identifier {
            var entry = Entry(identifier: identifier, name: name, postedInMain: postedInMain, text: text, dateCreated: dateCreated, likes: [])
            entry.save()
            completion(entry: entry)
        } else {
            completion(entry: nil)
        }
    }
    
    static func entryFromIdentifier(identifier: String, completion: (entry: Entry?) -> Void) {
        
        FirebaseController.dataAtEndpoint("entries/\(identifier)") { (data) -> Void in
            
            if let data = data as? [String: AnyObject] {
                let entry = Entry(json: data, identifier: identifier)
                
                completion(entry: entry)
            } else {
                completion(entry: nil)
            }
        }
    }
    
    static func entriesForUser(name: String, completion: (entries: [Entry]?) -> Void) {
        FirebaseController.base.childByAppendingPath("entries").queryOrderedByChild("name").queryEqualToValue(name).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            
            if let entryDictionaries = snapshot.value as? [String: AnyObject] {
                
                let entries = entryDictionaries.flatMap({Entry(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
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
    
//    static func addCommentWithTextToEntry(text: String, entry: Entry, completion: (success: Bool, entry: Entry?) -> Void?) {
//        
//        if let entryIdentifier = entry.identifier {
//            
//            var comment = Comment(username: UserController.sharedController.currentUser.username, text: text, postIdentifier: postIdentifier)
//            comment.save()
//            
//            PostController.postFromIdentifier(comment.postIdentifier) { (post) -> Void in
//                completion(success: true, post: post)
//            }
//        } else {
//            
//            var post = post
//            post.save()
//            var comment = Comment(username: UserController.sharedController.currentUser.username, text: text, postIdentifier: post.identifier!)
//            comment.save()
//            
//            PostController.postFromIdentifier(comment.postIdentifier) { (post) -> Void in
//                completion(success: true, post: post)
//            }
//        }
//    }
    
//    static func deleteComment(comment: Comment, completion: (success: Bool, post: Post?) -> Void) {
//        
//        comment.delete()
//        
//        PostController.postFromIdentifier(comment.postIdentifier) { (post) -> Void in
//            completion(success: true, post: post)
//        }
//    }

    
    static func addLikeToEntry(entry: Entry, completion: (success: Bool, entry: Entry?) -> Void) {
        
        var entry = entry
        entry.save()
        var like = Like(name: UserController.sharedController.currentUser.name!, entryIdentifier: entry.identifier)
        like.save()
        
        EntryController.entryFromIdentifier(entry.identifier, completion: { (post) -> Void in
            completion(success: true, entry: entry)
        })
    }
    
    static func deleteLike(like: Like, completion: (success: Bool, entry: Entry?) -> Void) {
        
        like.delete()
        
        EntryController.entryFromIdentifier(like.entryIdentifier) { (entry) -> Void in
            completion(success: true, entry: entry)
        }
    }
    
    static func orderEntries(entries: [Entry]) -> [Entry] {
        
        // sorts posts chronologically using Firebase identifiers
        return entries.sort({$0.0.identifier > $0.1.identifier})
    }
    
    static func mockEntries() -> [Entry] {
        
        let like1 = Like(name: "darth", entryIdentifier: "1234", identifier: "1243")
        let like2 = Like(name: "kenobi", entryIdentifier: "986", identifier: "9783")
        let like3 = Like(name: "luke", entryIdentifier: "78393", identifier: "927")
        
        let entry1 = Entry(identifier: "145", name: "Jay", postedInMain: true, text: "This is a sweet entry", dateCreated: NSDate(), likes: [like1,like2,like3])
        let entry2 = Entry(identifier: "14355", name: "Bob", postedInMain: true, text: "This is another sweet entry", dateCreated: NSDate(), likes: [like1,like2,like3])
        let entry3 = Entry(identifier: "18445", name: "Jeebus", postedInMain: false, text: "This is yet another sweet entry", dateCreated: NSDate(), likes: [like1,like2,like3])
        
        return [entry1, entry2, entry3]
    }
    
    
}





