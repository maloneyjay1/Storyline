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
    
    //CHANGE POSTEDINMAIN TO STRING OPTIONAL
    
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
    var likes: [String]
    var dateCreated: NSDate
    let name: String
    
    init(identifier: String, name: String = UserController.sharedController.currentUser.name!, postedInMain: Bool, text: String? = nil, dateCreated: NSDate, likes: [String] = []) {
        
        self.text = text!
        self.postedInMain = postedInMain
        self.likes = likes
        self.dateCreated = dateCreated
        self.identifier = identifier
        self.name = name
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "entry"
    
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [nameKey: self.name, likesKey: self.likes, TextKey: self.text, identiferKey: self.identifier, DateCreatedKey: self.dateCreated]
        
        if let postedInMain = self.postedInMain {
            json.updateValue(postedInMain, forKey: PostedInMainKey)
        }
        return json
    }
    
    //initialize json dictionary
    init?(json: [String: AnyObject], identifier: String) {
        
        //if json can store a property as? this type
        guard let name = json[nameKey] as? String,
            let identifier = json[identiferKey] as? String,
            let text = json[TextKey] as? String,
            let likeStringArray = json[likesKey] as? [String],
            let dateCreatedString = json[DateCreatedKey] as? String
//            let postedInMain = json[PostedInMainKey] as? Bool
        else {
        
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
        
        if let postedInMain = json[PostedInMainKey] as? Bool {
            self.postedInMain = postedInMain
        }
        
        
//        self.likes = // TODO: - /users/uid/likes/lid
        
        //self.likes = likeDictionaries.flatMap({Like(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
        self.likes = likeStringArray
        self.dateCreated = NSDate()
        
        let dateFormatter = NSDateFormatter()
        let date = dateFormatter.dateFromString(dateCreatedString)
        if let nsDate = date {
            self.dateCreated = nsDate
        }
        
    }
    
    func dictionaryOfEntry() -> [String:AnyObject] {

        return [TextKey: self.text,
            PostedInMainKey: self.postedInMain!,
            identiferKey: self.identifier,
            likesKey: self.likes,
            DateCreatedKey: self.dateCreated,
            nameKey: self.name,
        ]
    }
}


func ==(lhs:Entry, rhs:Entry) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.identifier == rhs.identifier)
    
}



