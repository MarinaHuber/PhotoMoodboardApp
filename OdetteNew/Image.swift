//
//  Image.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import SwiftyJSON
import AlamofireImage

enum ImageSize {
    case thumb
    case thumb2x
    case original
}

struct Image: Equatable {
    
    
    let imageName: String
    let order: Int?
    let dimensions: Dimensions?
    var tags: Array<Tag> = []
    var collectionId: Int
    
    //use this stored property it to store temporary selection
    var isSelected: Bool?
    
    fileprivate var imageURL: String {
        get {
            return "/img/collections/\(self.collectionId)/\(self.imageName)"
        }
    }
    
    let json: Dictionary<String, AnyObject>?
    
    func getURL (_ size: ImageSize) -> String {
        
        switch size {
        case ImageSize.original:
            return ("\(imageURL)/original.jpg")

        case ImageSize.thumb:
            return ("\(imageURL)/thumb.jpg")
        
        case ImageSize.thumb2x:
            return ("\(imageURL)/thumb2x.jpg")
        
        }

    }
    
    init (image: UIImage) {

        let name = UUID().uuidString
        let json = JSON(["image": name, "collection_id": 0])
        self = Image(json: json)

        
    }
    
    init(dict: NSDictionary) {
        self.init(json: JSON(dict))
    }
    
    init (json: JSON, collectionId: Int) {
        self = Image(json: json)
        self.collectionId = collectionId
    }
    
    init(json: JSON) {
        
        self.imageName = json["image"].stringValue
        self.order = json["order"].intValue
        self.dimensions = Dimensions(json: json["dimensions"])
        self.tags = json["tags"].arrayValue.map {
            Tag(json: $0)
        }
        self.collectionId = json["collection_id"].intValue

        self.json = json.dictionaryObject as Dictionary<String, AnyObject>?

    }
 
    
    
    
}


//DATAMANGER GETTERS
extension Image {
    
    
    var favorite: Bool {
        
        get {
            return (DataManager.sharedInstance.favoriteItems[imageName] != nil)
        }
        
        set (newValue) {
            
            if (newValue) {
                DataManager.addFavoriteImage(self)
            } else {
                DataManager.removeFavoriteImageByName(self.imageName)
            }
            
        }
    }
    
    
    
    var onMoodBoard: Bool {
        get {
            return DataManager.sharedInstance.moodBoardItems[imageName] != nil
        }
    }
    
    func addToMoodBoard(_ add: Bool) {
        if (add == true) {
            DataManager.addImageToMoodBoard(self)
        } else {
            DataManager.removeMoodBoardItemByName(self.imageName)
        }
        
    }
    
}



func ==(lhs: Image, rhs: Image) -> Bool {
    
    return lhs.imageName == rhs.imageName
}


