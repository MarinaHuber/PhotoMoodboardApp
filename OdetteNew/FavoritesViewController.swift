//
//  FavoritesViewController.swift
//  OdetteNew
//
//  Created by Marina Huber on 06/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import AlamofireImage
import Haneke




class FavoritesViewController: WaterfallGenericVC {


    var test = ["testschaal3.jpg", "testschaal3.jpg", "testschaal3.jpg"]
    var cellSizes = [CGSize]()


    
//MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        }
    
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         }

    
    //MARK: Delegate
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCell
        cell.image = images[indexPath.row]
        //logic for deleting favorites
        //TODO: refresh only affected cell
        cell.deleteClosure = {
            image in

            if let name = image?.imageName {
                DataManager.deleteItemByImageName(name)
                self.images = DataManager.getFavoriteItems()
                collectionView.reloadData()
            }
            
            
        }
        
        
        return cell

        
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
   
    
        }

    }


