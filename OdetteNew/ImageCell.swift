//
//  ImageCell.swift
//  OdetteNew
//
//  Created by Marina Huber on 5/25/16.
//  Copyright © 2016 xs2. All rights reserved.
//


import UIKit
import AlamofireImage
import Haneke

@IBDesignable
 class ImageCell: UICollectionViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var moodboardFavorites: UIButton!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var favorites: UIButton!
    var previousTask: NSURLSessionDataTask?
    var deleteClosure: ((Image?)->())?
    
    var path: NSIndexPath?
    var image: Image! {
        
        didSet {
            self.backgroundImage.image = UIImage()
            
            if (image != nil) {
                NetworkManager.getFromCacheOrNetwork(image, applyImage: {
                    imageLoaded, error in
                    
                    if (imageLoaded != nil) {
                        if (error == nil) {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.backgroundImage.image = imageLoaded
                                
                                self.setNeedsDisplay()
                                
                                self.backgroundImage.alpha = 0
                                UIView.animateWithDuration(0.5, animations: {
                                    self.backgroundImage.alpha = 1
                                })
                            })
                        }
                    }
                })
            }

            
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundImage.image = nil
        self.previousTask?.cancel()
    }
    
    
//action for deleting images
    @IBAction func deleteImage() {
        deleteClosure?(image)
    }

}


