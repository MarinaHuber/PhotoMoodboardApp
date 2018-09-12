//
//  Tag.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import SwiftyJSON

struct Tag {
     //these tags are shared for collection pages& collection ID
    let id: Int
    let name: String
    let order: Int?

    let json: Dictionary<String, AnyObject>?
    
//    init(id: Int, name: String, order: Int) {
//        
//        self.id = id
//        self.name = name
//        self.order = order
//        
//    }
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue.capitalized
        self.order = json["order"].intValue

        self.json = json.dictionaryObject as Dictionary<String, AnyObject>?
    }
}


