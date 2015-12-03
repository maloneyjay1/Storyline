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
        
        
        UserController.authenticateUser("vader@empire.gov", password: "obiSucks101") { (success, user) -> Void in
            print("\(success, user)")
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

