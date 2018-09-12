//
//  WaterfallGenericVC.swift
//  OdetteNew
//
//  Created by Marina Huber on 25/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import AlamofireImage
import Haneke


protocol WaterfallViewControllerDelegate {
    func gotTagSearchUpdate(tag: String?)

  }


class WaterfallGenericVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, WaterfallViewControllerDelegate, CollectionViewWaterfallLayoutDelegate {
    
    var collectionView: UICollectionView!
    var images = Array<Image>()
    var tags = Array<Tag>()
    var layout = CollectionViewWaterfallLayout()
    
    
//MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        layout.sectionInset = UIEdgeInsets(top: 90, left: 30, bottom: 20, right: 30)
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        switch UIDevice().userInterfaceIdiom {
        case UIUserInterfaceIdiom.Pad:
            layout.columnCount = 3
        default:
            layout.columnCount = 1
        }
        // doesn't support rotation
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        collectionView.reloadData()
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.backgroundColor = Colors.lightGray
        
        view.addSubview(collectionView)

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    


  
    
    func reloadUI() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.collectionView.reloadData()
        })
     }


    
    func gotTagSearchUpdate(tag: String?) {
      
        
    }
    func searchImages(tag: String?) {
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



//MARK: - UICollectionView

    
    //MARK: DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCell
        cell.image = images[indexPath.row]
        return cell
    }
    
    //MARK: Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: - UICollectionViewWaterfallLayout Delegate

    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let image = images[indexPath.row]
        return image.dimensions.thumb
    }
 
    
    
}


