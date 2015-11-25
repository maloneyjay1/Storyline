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
    
    let text: String?
    var postedInMain: Bool?
    var identifier: String?
    let likes: [Like]
    let dateCreated: Double?
    let name: String?
    
    init(identifier: String?, name: String = UserController.sharedController.currentUser.name!, postedInMain: Bool, text: String? = nil, dateCreated: Double? = nil, likes: [Like] = []) {
        
        self.text = text
        self.postedInMain = postedInMain
        self.likes = likes
        self.dateCreated = dateCreated
        
    }
    
    //MARK: FirebaseType
    
    var endpoint: String = "entry"
    
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [nameKey: self.name!, likesKey: self.likes.map({$0.jsonValue})]
        
                if let text = self.text {
        
                    json.updateValue(text, forKey: TextKey)
                }
                
                return json
            }
    
        init?(json: [String: AnyObject], identifier: String?) {
    
            guard let name = json[nameKey] as? String else {
    
                    self.name = ""
                    self.identifier = ""
    
                    return nil
            }
    
            self.likes = (json[likesKey] as? [Like])!
            self.name = name
            self.identifier = identifier
    
            if let likeDictionaries = json[likesKey] as? [String: AnyObject] {
                self.likes = likeDictionaries.flatMap({Like(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
            } else {
                self.likes = []
            }
        }
        
    }

func ==(lhs:Entry, rhs:Entry) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.identifier == rhs.identifier)
}
