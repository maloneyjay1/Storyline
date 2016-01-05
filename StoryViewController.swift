//
//  StoryViewController.swift
//  storyLine
//
//  Created by Jay Maloney on 12/16/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //                UserController.createFirebaseUser("vader@empire.gov", name: "Darth Vader", password: "obihater101") { (success, user) -> Void in
        //                    if success == true {
        //                        print("Success for \(user).")
        //                    } else {
        //                        print("Failure.")
        //                    }
        //                }
        
        
//                UserController.authenticateUser("vader@empire.gov", password: "obihater101") { (success, user) -> Void in
//                    if success {
//                        print("\(user) authenticated.")
//                    } else {
//                        print("Failure to Authenticate.")
//                    }
//                }
        
        
        //                EntryController.createEntry(UserController.sharedController.currentUser.uid!, name: UserController.sharedController.currentUser.name!, text: "Sample Entry", dateCreated: NSDate()) { (success, dateCreated, eid, newEntry) -> Void in
        //
        //                    if let name = UserController.sharedController.currentUser.name {
        //
        //                        if success {
        //
        //                            print("\(eid) created successfully!  Thank you \(name) for your entry, Entry:\(eid) created at \(dateCreated)")
        //                        } else {
        //                            print("Sorry, try again!")
        //                        }
        //                    }
        //                }
        
        
        
        
        //        StoryController.createStory(UserController.sharedController.currentUser.uid!, dateCreated: NSDate(), storyPrompt: "Once upon a time:") { (success, newStory, dateCreated, sid) -> Void in
        //
        //            if let uid = UserController.sharedController.currentUser.uid {
        //                if success {
        //                    print("\(newStory): \(sid) created successfully by user \(uid) at \(dateCreated)")
        //                } else {
        //                    print("Sorry, try again.")
        //                }
        //            }
        //        }
        
        
        
        var myEntries:[Entry] = []
        var allStories:[Story] = []
        EntryController.fetchEntriesForUser(UserController.sharedController.currentUser) { (entries) -> Void in
            if let entries = entries {
                print("\(entries)")
                
                myEntries = entries
                print("\(myEntries)")
                
                let myEntry = myEntries[1]
                
                EntryController.fetchStories({ (stories) -> Void in
                    if let stories = stories {
                        print("\(stories)")
                        
                        allStories = stories
                        print("\(allStories)")
                        
                        let currentStory = allStories[0]
                        
                        EntryController.addEntryToStory(myEntry, story: currentStory, completion: { (success) -> Void in
                            if success {
                                print("Successfully added \(myEntry) to \(currentStory).")
                            } else {
                                print("Error adding \(myEntry) to \(currentStory).")
                            }
                            
                        })
                    }
                })
            }
        }
        
            
            //
            //        var myEntries:[Entry] = []
            //        EntryController.fetchEntriesForUser(UserController.sharedController.currentUser) { (entries) -> Void in
            //            if let entries = entries {
            //                print("\(entries)")
            //
            //                myEntries = entries
            //                print("\(myEntries)")
            //
            //                let myEntry = myEntries[1]
            //
            //                EntryController.addLikeToEntry(myEntry) { (success) -> Void in
            //
            //                    if success {
            //                        print("Successfully liked entry.")
            //                    } else {
            //                        print("Error adding Like to Entry.")
            //                    }
            //                }
            //
            //            } else {
            //                print("Error fetching entries for user.")
            //            }
            //        }
            
            
            //
            //        //TESTING likesForEntry
            //        var myEntries:[Entry] = []
            //        EntryController.fetchEntriesForUser(UserController.sharedController.currentUser) { (entries) -> Void in
            //            if let entries = entries {
            //
            //                myEntries = entries
            //
            //                let myEntry = myEntries[0]
            ////
            ////                    let myLikesForEntry:[Entry] = []
            //
            //                    EntryController.likesForEntry(myEntry, completion: { (success) -> Void in
            //                        if success {
            //
            ////                            myLikesForEntry.append(entry)
            //                            print("Success Finding Likes.")
            ////                            if myLikesForEntry.count == 1 {
            ////
            ////                                print("You have \(myLikesForEntry.count) like for entry!")
            ////                            } else {
            ////                                print("You have \(myLikesForEntry.count) likes for entry!")
            ////                            }
            //
            //                        } else {
            //                            print("Error finding likes for entry.")
            //                        }
            //                    })
            //
            //
            //            } else {
            //                print("Error fetching entries for user.")
            //            }
            //        }
            
            
            //
            //        var myEntries:[Entry] = []
            //        EntryController.fetchEntriesForUser(UserController.sharedController.currentUser) { (entries) -> Void in
            //            if let entries = entries {
            //
            //                myEntries = entries
            //
            //                let myEntry = myEntries[0]
            //
            //                EntryController.entryOfTheDay(myEntry, completion: { (highest) -> Void in
            //                    if (highest != nil) {
            //                        print("success")
            //
            //                    } else {
            //                        print("Failure finding user for liked Entry.")
            //                    }
            //                })
            //            } else {
            //                print("Error fetching entries for user.")
            //            }
            //        }
            
            
            
            
            
            //
            //                var myEntries:[Entry] = []
            //                EntryController.fetchEntriesForUser(UserController.sharedController.currentUser) { (entries) -> Void in
            //                    if let entries = entries {
            //
            //                        myEntries = entries
            //
            //                        let myEntry = myEntries[0]
            //
            ////                            let myLikesForEntry:[Entry] = []
            //
            //                            EntryController.userForLikedEntry(myEntry, completion: { (success) -> Void in
            //
            //                                if success {
            //
            //                                    print("success")
            //
            //                                } else {
            //                                    print("Failure finding user for liked Entry.")
            //                                }
            //                            })
            //                        
            //                    } else {
            //                        print("Error fetching entries for user.")
            //                    }
            //                }
            //        
            
            
            
            
            //                                EntryController.fetchEntriesForUser(UserController.sharedController.currentUser) { (entries) -> Void in
            //                                    if let entries = entries {
            //                                        print(entries)
            //                                    }
            //                                }
            //        
            //
            //                EntryController.entriesForUser(UserController.sharedController.currentUser.uid) { (entries) -> Void in
            //                    if let entries = entries {
            //                        print("\(entries)")
            //                    }
            //                }
            //        
            //        
            //        
            
            
            
            
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
        */
        
    }
