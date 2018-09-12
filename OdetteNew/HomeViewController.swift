//
//  HomeViewController.swift
//  OdetteNew
//
//  Created by Marina Huber on 5/25/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import AlamofireImage
import Haneke




class HomeViewController: WaterfallGenericVC {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchImages("")
        
    }
    
    override func searchImages(tag: String?) {
        if let t = tag {
            NetworkManager.getImagesByTag(t, completionHandler: {
                error, imagesLoaded in
                self.images = imagesLoaded ?? []
                self.reloadUI()
            })
            
        } else {
            NetworkManager.getAllImages { error, imagesLoaded in
                self.images = imagesLoaded!
                self.reloadUI()
            }
        }
    }
    


    //MARK: Delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //to pass view image PERFORMSEGUE
        let image = self.images[indexPath.row].collectionId
        performSegueWithIdentifier("segueDetail", sender: image)
    
        
    }
    
}
