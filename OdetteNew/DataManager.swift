//
//  DataManager.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import SwiftyJSON
import Haneke


class DataManager {
    
    
    static let sharedInstance = DataManager()
    
    var storedFavoriteItems: Dictionary<String, Image>? = nil
    
    var favoriteItems: Dictionary<String, Image> {
        get {
            return storedFavoriteItems ?? loadFavoriteItems()
        }

        set (newValue) {
            
            storedFavoriteItems = newValue
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
                self.saveFavoriteItems(newValue)
                
            })
            
    
            
        }
    }

    var moodBoardItems: Dictionary<String, MoodboardItem> {
        get {
            return loadMoodBoardItems()
        }
        
        set (newValue) {
            saveMoodboardItems(newValue)
        }
    }
    
    var tags: Array<Tag>? = nil
    
    init () {
        
    }
    
    enum FileStore: String {
        case MoodBoard = "moodboard.data"
        case Favorite = "favorite.data"
        
    }
    
    func getDocumentsDirectoryURL() -> URL? {
        let fileManager = FileManager()
        if let docsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            return docsDirectory
        }
        return nil
    }
    
    
    //MARK: - Image
    
    class func saveImage(_ image: UIImage, name: String) {
        let cache = Shared.imageCache
        cache.set(value: image, key: name)
        
    }
    
    class func getCachedImage (_ imageURL: String) -> UIImage? {
        let cache = Shared.imageCache
        var img: UIImage? = nil
        cache.fetch(key: imageURL)
            .onSuccess({
                image in
                img = image
            })
        return img
    }
    
    class func getImage (_ imageURL: String, completionHandler: @escaping ((String, UIImage?, NSError?) -> ())) {
        
        
        let cache = Shared.imageCache
        
        cache.fetch(key: imageURL)
            .onFailure({
                error in
                
                NetworkManager.loadStaticImage(imageURL, completionHandler: {
                    imageURL, loadedImage, error1 in
                    
                    if (loadedImage != nil) {
                      self.saveImage(loadedImage!, name: imageURL)
                    }
                    completionHandler (imageURL, loadedImage, error1 ?? error as NSError?)
                    
                })
                
            })
            .onSuccess({
                image in
                
                completionHandler (imageURL, image, nil)
            })
        
    }
    
    
    
    //MARK: - Tags storage
    
    class func getTags(_ completionHandler: @escaping (Array<Tag>?) -> ())  {
        
        //check if we have tags saved, if yes - just return them
        if let tagsSaved = sharedInstance.tags, tagsSaved.count > 0
        {
            
            completionHandler(tagsSaved)
            
        } else {
            
            
            NetworkManager.getTags({
                error, tags in
                
                //if we successgully loaded some tags
                if let tagsLoaded = tags, error == nil {
                    
                    //save them to datamanager and return to the caller
                    sharedInstance.tags = tagsLoaded
                    completionHandler (tagsLoaded)
                    
                } else {
                    //return empty array if any error occured
                    print ("error on loading tags: \(tags)")
                    completionHandler ([])
                }
                
            })
            
        }
        
    }
    
    
    //MARK: - Moodboard
    class func addMoodBoardItems (_ newItems: Array<MoodboardItem>) {

        var tempDict = sharedInstance.moodBoardItems
        _ = newItems.map {
            
            if !tempDict.keys.contains($0.imageMoodboard.imageName) {
                tempDict[$0.imageMoodboard.imageName] = $0
            }
        }
        sharedInstance.moodBoardItems = tempDict

    }

    
    
    class func addImageToMoodBoard (_ newItem: Image) {
        
        var tempDict = sharedInstance.moodBoardItems
        if !tempDict.keys.contains(newItem.imageName) {
            tempDict[newItem.imageName] = MoodboardItem(image: newItem)
        }
        
        sharedInstance.moodBoardItems = tempDict
    }

    
    class func addImagesToMoodBoard (_ newItems: Array<Image>) {
        
        var tempDict = sharedInstance.moodBoardItems
        _ = newItems.map {
            
            if !tempDict.keys.contains($0.imageName) {
                tempDict[$0.imageName] = MoodboardItem(image: $0)
            }
        }
        sharedInstance.moodBoardItems = tempDict
    }

    
    
    class func removeMoodBoardItem (_ itemToRemove: MoodboardItem) {
        sharedInstance.moodBoardItems.removeValue(forKey: itemToRemove.imageMoodboard.imageName)
    }
    
    class func removeMoodBoardItemByName (_ imageName: String) {
        sharedInstance.moodBoardItems.removeValue(forKey: imageName)
    }
    
    
    class func getMoodBoardItems() -> Array<MoodboardItem> {
        return sharedInstance.moodBoardItems.map {
            key, value in
            return value
        }
    }
    
    class func updateMoodBoardItem(_ item: MoodboardItem) {
        
        
        var tempDict = sharedInstance.moodBoardItems
        tempDict[item.imageMoodboard.imageName] = item
        sharedInstance.moodBoardItems = tempDict
    }
    
    
    
    class func updateMoodBoardItems (_ items: Array<MoodboardItem>) {
        var dict: Dictionary<String, MoodboardItem> = [:]
        _ = items.map {
            dict[$0.imageMoodboard.imageName] = $0
        }
        sharedInstance.moodBoardItems = dict
    }
    
    
    //MARK: - Favorites
    
    class func addFavoriteImages (_ imgs: Array<Image>) {
        var imgArr = sharedInstance.favoriteItems
       _ = imgs.map {
            imgArr[$0.imageName] = $0
        }
        sharedInstance.favoriteItems = imgArr
    }
    
    class func removeFavoriteImages (_ imgs: Array<Image>) {
    var favItems = sharedInstance.favoriteItems

        _ = imgs.map {
            favItems.removeValue(forKey: $0.imageName)
        }
        sharedInstance.favoriteItems = favItems
    }
    
    
    class func addFavoriteImage (_ image: Image) {
        sharedInstance.favoriteItems[image.imageName] = image
    }
    
    
    class func removeFavoriteImageByName (_ imageName: String) {
        sharedInstance.favoriteItems.removeValue(forKey: imageName)
    }
    
    class func getFavoriteItems() -> Array<Image> {
        
        return sharedInstance.favoriteItems.map {
            key, value in
            return value
        }
    }
    
    
    //MARK: - MoodBoard private getters/setters
    fileprivate  func saveMoodboardItems (_ items: Dictionary<String, MoodboardItem>) {
        
        let objects: NSArray = items.values.map {
            RMoodBoardImage(item: $0)
        }
        
        if let path = getDocumentsDirectoryURL()?.appendingPathComponent(FileStore.MoodBoard.rawValue).path {
            NSKeyedArchiver.archiveRootObject(objects, toFile: path)
        }
        
    }
    
    
    fileprivate func loadMoodBoardItems() -> Dictionary<String, MoodboardItem> {
        
        if let path = getDocumentsDirectoryURL()?.appendingPathComponent(FileStore.MoodBoard.rawValue).path {
            
            let objects: Array<RMoodBoardImage> = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Array<RMoodBoardImage> ?? []
            
            var dict: Dictionary <String, MoodboardItem> = [:]
            _ = objects.map {
                if let item = $0.moodBoardItem {
                    dict[item.imageMoodboard.imageName] = item
                }
            }
            
            return dict
        }
        
        print ("no file data found for moodboard")
        return [:]
        
    }
    
    
    //MARK: - Favorites private getters and setters
    fileprivate func saveFavoriteItems (_ items: Dictionary<String, Image>) {
        
        
        let objects: NSArray = items.values.map {
            RImage(item: $0)
        }
        
//        print ("save \(objects.count) fav items")
        if let path = getDocumentsDirectoryURL()?.appendingPathComponent(FileStore.Favorite.rawValue).path {
            NSKeyedArchiver.archiveRootObject(objects, toFile: path)
        }
        
        
    }
    
   fileprivate func loadFavoriteItems () -> Dictionary<String, Image> {
        
        if let path = getDocumentsDirectoryURL()?.appendingPathComponent(FileStore.Favorite.rawValue).path {
            
            let objects: Array<RImage> = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Array<RImage> ?? []
            
            var dict: Dictionary <String, Image> = [:]
            _ = objects.map {
                if let item = $0.item {
                    dict[item.imageName] = item
                }
            }
            
            return dict
        }
    
        print ("no file data found for favorites")

        return [:]
        
    }
    
}
