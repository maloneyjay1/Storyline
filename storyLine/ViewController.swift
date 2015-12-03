//
//  ViewController.swift
//  storyLine
//
//  Created by Jay Maloney on 11/16/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        UserController.createUser("vader@empire.gov", name: "Darth Vader", password: "obiSucks101", url: "") { (success) -> Void in
            print("User Created")
        }
        
//        EntryController.addEntry("Identifier", name: "-K4_7B3WGQGya2DJ4H3t", postedInMain: false, text: "Text", dateCreated: NSDate()) { (identifier) -> Void in
//            
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

