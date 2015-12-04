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
        
//        UserController.createUser("vader@empire.gov", name: "Darth Vader", uid: "", id: "", password: "obiSucks101", url: "url") { (success) -> Void in
//        }
        
        UserController.updateUser("anakin@skywalker.com", name: "Anakin Skywalker", uid: "", id: "", password: "obiSucks01", url: "url") { (success, user) -> Void in
            print(success, user)
        }
        

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

