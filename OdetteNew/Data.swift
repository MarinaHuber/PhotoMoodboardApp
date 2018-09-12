//
//  Information.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//
import UIKit
//import SwiftyJSON


struct Data {
    
    let info: String?
    let collection: String
    let description: String
    let title: String
    let conceptStore_URL: String?
    let advice_URL: String?

    let json: Dictionary<String, AnyObject>?

    init(json: JSON) {
        
        self.info = json["information"].stringValue
        self.collection = json["collection"].stringValue
        self.description = json["description"].stringValue
        self.title = json["title"].stringValue
        self.conceptStore_URL = json["conceptstore_url"].string
        self.advice_URL = json["advice_url"].string
     
        self.json = json.dictionaryObject as Dictionary<String, AnyObject>?
    }
    
}
