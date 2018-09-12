//
//  RealmModels.swift
//  OdetteNew
//
//  Created by Eugene Braginets on 9/5/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import SwiftyJSON


class RMoodBoardImage: NSObject {
    
    
    dynamic var transformString: String!
    dynamic var object: NSDictionary!
    dynamic var zIndex: Int = 0

    init (item: MoodboardItem) {
       
        super.init()
        self.transform = item.transform
        self.object = item.imageMoodboard.json as NSDictionary!
        self.zIndex = item.zIndex
        
    }

    var moodBoardItem: MoodboardItem? {
        get {
            return MoodboardItem(image: Image(dict:self.object), transformMatrix: transform, zIndex: zIndex)
        }
    }
    
    var transform: CGAffineTransform! {
        
        set (newValue) {
            self.transformString = NSStringFromCGAffineTransform(newValue)
        }
        
        get {
            return CGAffineTransformFromString(transformString ?? NSStringFromCGAffineTransform(CGAffineTransform()))
        }
    }
    
    
    func encodeWithCoder (_ coder: NSCoder) {
        coder.encode(self.transformString, forKey: "transformString")
        coder.encode(self.object, forKey: "object")
        coder.encode(self.zIndex, forKey: "zIndex")
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.object =  aDecoder.decodeObject(forKey: "object") as? NSDictionary
        self.transformString = aDecoder.decodeObject(forKey: "transformString") as? String
        self.zIndex = aDecoder.decodeInteger(forKey: "zIndex") ?? 0
    }
    
    
}


class RImage: NSObject {
    
    dynamic var object: NSDictionary!
    
    init (item: Image) {
        
        super.init()
        self.object = item.json as NSDictionary!
        
    }
    
    var item: Image? {
        get {
            return Image(dict:self.object)
        }
    }
    
    
    func encodeWithCoder (_ coder: NSCoder) {
        coder.encode(self.object, forKey: "object")
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.object =  aDecoder.decodeObject(forKey: "object") as? NSDictionary
        
    }
    
    
}



