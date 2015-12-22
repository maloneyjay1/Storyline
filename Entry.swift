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
    private let nameKey = "name"
    private let UIDKey = "uid"
    private let EIDKey = "eid"
    
    let text: String
    var dateCreated: NSDate
    let name: String
    var uid: String?
    let eid: String?
    

    init(uid: String, eid: String, name: String = UserController.sharedController.currentUser.name!, text: String? = nil, dateCreated: NSDate) {
        
        self.text = text!
        self.dateCreated = dateCreated
        self.uid = uid
        self.name = name
        self.eid = eid
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "entries"
    
    var jsonValue: [String: AnyObject] {
        
        let json: [String: AnyObject] = [nameKey: self.name, TextKey: self.text, UIDKey: self.uid!, EIDKey: self.eid!, DateCreatedKey: self.dateCreated]
        
        return json
    }
    
    //initialize json dictionary
    init?(json: [String: AnyObject], uid: String) {
        
        //if json can store a property as? this type
        guard let name = json[nameKey] as? String,
            let uid = json[UIDKey] as? String,
            let eid = json[EIDKey] as? String,
            let text = json[TextKey] as? String,
            let dateCreatedString = json[DateCreatedKey] as? String
            
            else {
                
                // failure to create temporary objects, give these values
                self.name = ""
                self.uid = UserController.sharedController.currentUser.uid
                self.eid = ""
                self.text = ""
                self.dateCreated = NSDate()
                
                
                return nil
        }
        
        self.text = text
        self.name = name
        self.uid = uid
        self.eid = eid
        self.dateCreated = NSDate()
        let dateFormatter = NSDateFormatter()
        let date = dateFormatter.dateFromString(dateCreatedString)
        if let nsDate = date {
            self.dateCreated = nsDate
        }
        
    }
    
    mutating func dictionaryOfEntry() -> [String:AnyObject] {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let dateString = dateFormatter.stringFromDate(date)
        
        return [TextKey: self.text,
            UIDKey: self.uid!,
            EIDKey: self.eid!,
            //            likesKey: self.likes,
            DateCreatedKey: dateString,
            nameKey: self.name,
        ]
    }
}


func ==(lhs:Entry, rhs:Entry) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.uid == rhs.uid)
    
}



