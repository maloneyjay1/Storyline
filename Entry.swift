//
//  Entry.swift
//  storyLine
//
//  Created by Jay Maloney on 11/19/15.
//  Copyright © 2015 Jay Maloney. All rights reserved.
//

import Foundation
import UIKit

struct Entry: Equatable, FirebaseType {
    
    private let URLKey = "url"
    private let TextKey = "text"
    private let DateCreatedKey = "dateCreated"
    private let PostedInMainKey = "postedInMain"
    private let identiferKey = "identifier"
    private let likesKey = "likes"
    private let nameKey = "name"
    
    let text: String
    var postedInMain: Bool?
    var identifier: String
    var likes: [Like]
    var dateCreated: NSDate
    let name: String
    
    init(identifier: String?, name: String = UserController.sharedController.currentUser.name!, postedInMain: Bool, text: String? = nil, dateCreated: NSDate, likes: [Like] = []) {
        
        self.text = text!
        self.postedInMain = postedInMain
        self.likes = likes
        self.dateCreated = dateCreated
        self.identifier = identifier!
        self.name = name
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "entry"
    
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [nameKey: self.name, likesKey: self.likes.map({$0.jsonValue}), TextKey: self.text, identiferKey: self.identifier, DateCreatedKey: self.dateCreated]
        
        if let postedInMain = self.postedInMain {
            json.updateValue(postedInMain, forKey: PostedInMainKey)
        }
        return json
    }
    //initialize json dictionary
    init?(json: [String: AnyObject], identifier: String?) {
        
        //if json can store a property as? this type
        guard let name = json[nameKey] as? String,
            let identifier = json[identiferKey] as? String,
            let text = json[TextKey] as? String,
            let likeDictionaries = json[likesKey] as? [String:AnyObject],
            let dateCreatedString = json[DateCreatedKey] as? String,
            let postedInMain = json[PostedInMainKey] as? Bool else {
                
                // failure to create temporary objects, give these values
                self.name = ""
                self.identifier = ""
                self.text = ""
                self.dateCreated = NSDate()
                self.postedInMain = false
                self.likes = []
                
                return nil
        }
        
        // success, set (self's) object properties to temporary object
        self.text = text
        self.name = name
        self.identifier = identifier
        self.postedInMain = postedInMain
        self.likes = likeDictionaries.flatMap({Like(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
        
        self.dateCreated = NSDate()
        
        let dateFormatter = NSDateFormatter()
        let date = dateFormatter.dateFromString(dateCreatedString)
        if let nsDate = date {
            self.dateCreated = nsDate
        }
        
        
        //        if let likeDictionaries = json[likesKey] as? [String: AnyObject] {
        //            self.likes = likeDictionaries.flatMap({Like(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
        //        } else {
        //            print("ERROR no [Like] in json[likesKey]")
        //            self.likes = []
        //        }
    }
    
}

func ==(lhs:Entry, rhs:Entry) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.identifier == rhs.identifier)
}
