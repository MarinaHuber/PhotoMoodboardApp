//
//  Collection.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import Foundation
//import SwiftyJSON

struct Collection {
    
    let id: Int
    let activatedAt: Int
    let data: Data?
    var imageCollection: Array<Image> = []
    var tags: Array<Tag> = []
    let cover: Image?
    let artist: Image?

    
    let json: Dictionary<String, AnyObject>?
   
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.activatedAt = json["timestamp"].intValue
        self.data = Data(json: json["data"])
        self.imageCollection = json["images"].arrayValue.map {
            Image(json: $0)
        }
        self.tags = json["tags"].arrayValue.map {
            Tag(json: $0)
        }
        self.cover = Image(json: json["cover"], collectionId: self.id)
        self.artist = Image(json: json["display"]["artist"], collectionId: self.id)

        
        self.json = json.dictionaryObject as Dictionary<String, AnyObject>?
    }
    
    
}




