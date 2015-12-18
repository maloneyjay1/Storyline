//
//  LoginPickerViewViewController.swift
//  storyLine
//
//  Created by Jay Maloney on 12/16/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import UIKit

class LoginPickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationViewController = segue.destinationViewController as? LoginSignupViewController {
            
            if segue.identifier == "toLogin" {
                destinationViewController.mode = .Login
            }
            
            if segue.identifier == "toSignup" {
                destinationViewController.mode = .Signup
            }
        }
    }


}
