//
//  Dimentions.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import SwiftyJSON


struct Dimensions {
    
    let thumb: CGSize
    let thumb_2x: CGSize
    let original: CGSize
    
    let json: Dictionary<String, AnyObject>?
    
//    init(thumb: CGSize, thumb_2x: CGSize, original: CGSize) {
//        
//        self.thumb = thumb
//        self.thumb_2x = thumb_2x
//        self.original = original
//        
//    }
//    
    init(json: JSON) {
        
        self.thumb = CGSize(width: json["thumb"]["width"].doubleValue, height: json["thumb"]["height"].doubleValue)
        self.thumb_2x = CGSize(width: json["thumb_2x"]["width"].doubleValue, height: json["thumb_2x"]["height"].doubleValue)
        self.original = CGSize(width: json["original"]["width"].doubleValue, height: json["original"]["height"].doubleValue)
        
        self.json = json.dictionaryObject as Dictionary<String, AnyObject>?
    }
 
    

    
}

