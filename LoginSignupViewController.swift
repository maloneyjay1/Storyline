//
//  LoginSignupViewController.swift
//  storyLine
//
//  Created by Jay Maloney on 12/7/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupTap(sender: AnyObject) {
        let mode: ViewMode = .Signup
        updateViewForMode(mode)
    }
    
    @IBAction func loginTap(sender: AnyObject) {
        let mode: ViewMode = .Login
        updateViewForMode(mode)
    }
    
    @IBAction func updateTap(sender: AnyObject) {
        let mode: ViewMode = .Update
        updateViewForMode(mode)
    }
    
    
    enum ViewMode {
        case Login
        case Signup
        case Update
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    
    
    var mode: ViewMode = .Signup
    var user: User?
    
    var fieldsAreValid: Bool {
        
        switch mode {
            
        case .Login:
            
            return !(emailField.text!.isEmpty || passwordField.text!.isEmpty)
            
        case .Signup:
            
            return !(nameField.text!.isEmpty || emailField.text!.isEmpty || passwordField.text!.isEmpty)
            
        case .Update:
            
            return !(nameField.text!.isEmpty)
            
        }
    }
    
    
    func updateViewForMode(mode: ViewMode) {
        
        switch mode {
            
        case .Signup:
            
            actionButton.setTitle("Sign up", forState: .Normal)
            
        case .Login:
            
            actionButton.setTitle("Log In", forState: .Normal)
            
            nameField.removeFromSuperview()
            
        case .Update:
            
            actionButton.setTitle("Update", forState: .Normal)
            
            emailField.removeFromSuperview()
            passwordField.removeFromSuperview()
            
            if let user = self.user {
                
                nameField.text = user.name
            }
        }
    }
    
    @IBAction func actionButtonTapped(sender: AnyObject) {
        
        if fieldsAreValid {
            switch mode {
                
            case .Signup:
                
                UserController.createFirebaseUser(emailField.text!, name: nameField.text!, password: passwordField.text!, completion: { (success, user) -> Void in
                    if success {
                        let user = UserController.sharedController.currentUser
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.presentValidationAlertWithTitle("Success!", text: "Thank you, \(user.name), your account at \(user.email) is now active.")
                        
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Create User", text: "Please check your information and try again.")
                    }
                    
                })
                
            case .Login:
                
                UserController.authenticateUser(emailField.text!, password: passwordField.text!, completion: { (success, user) -> Void in
                    
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Log In", text: "Please check your information and try again.")
                    }
                })
                
            case .Update:
                
                UserController.updateUser(self.user!, name: self.nameField.text!, completion: { (success, user) -> Void in
                    
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Update User", text: "Please check your information and try again.")
                    }
                })
            }
        } else {
            self.presentValidationAlertWithTitle("Missing Information", text: "Please check info again.")
        }
    }
    
    func updateWithUser(user: User) {
        
        self.user = user
        mode = .Update
        
        updateViewForMode(mode)
    }
    
    
    func presentValidationAlertWithTitle(title: String, text: String) {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //        EntryController.addLikeToFB(UserController.sharedController.currentUser.uid) { (success) -> Void in
        //            if success {
        //                print(success)
        //            } else {
        //                print("error")
        //            }
        //        }
        
        
        //        EntryController.entriesForUser(UserController.sharedController.currentUser.uid) { (entries) -> Void in
        //            if let entries = entries {
        //                print(entries)
        //            } else {
        //                print("error")
        //            }
        //        }
        
        //
        //                        EntryController.fetchEntriesForUser(UserController.sharedController.currentUser) { (entries) -> Void in
        //                            if let entries = entries {
        //                                print("\(entries)")
        //                            } else {
        //                                print("error")
        //                            }
        //                        }
        //
        //
        
        //        EntryController.entryFromIdentifier(UserController.sharedController.currentUser, uid: UserController.sharedController.currentUser.uid) { (entry) -> Void in
        //
        //            print("\(entry)")
        //
        //        }
        
        
        
        
        //                UserController.createFirebaseUser("vader@empire.gov", name: "Darth Vader", password: "obihater101") { (success, user) -> Void in
        //                    if success == true {
        //                        print("Success for \(user).")
        //                    } else {
        //                        print("Failure.")
        //                    }
        //                }
        
        
        
        //        EntryController.createEntry(UserController.sharedController.currentUser.uid, name: UserController.sharedController.currentUser.name!, text: "Sample Entry", dateCreated: NSDate()) { (success, dateCreated, eid, newEntry) -> Void in
        //
        //            if let name = UserController.sharedController.currentUser.name {
        //
        //                if success == true {
        //
        //                    print("\(eid) created successfully!  Thank you \(name) for your entry, Entry:\(eid) created at \(dateCreated)")
        //                } else {
        //                    print("Sorry, try again!")
        //                }
        //            }
        //        }
        
        
        //        UserController.updateUser(UserController.sharedController.currentUser, name: "Anakin Dudebro") { (success, user) -> Void in
        //            if success {
        //                print("Success.")
        //            } else {
        //                print("Fail.")
        //            }
        //        }
        
        
        //        UserController.authenticateUser("vader@empire.gov", password: "yoda101") { (success, user) -> Void in
        //
        //
        //            EntryController.entriesForUser(UserController.sharedController.currentUser.name!, completion: { (entries) -> Void in
        //                if let entries = entries {
        //                    print("\(entries)")
        //                } else {
        //                    print("No Entries for \(UserController.sharedController.currentUser.name)")
        //                }
        //            })
        //
        //
        
        
        updateViewForMode(mode)
    }
}



