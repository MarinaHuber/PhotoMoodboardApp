//
//  ViewController.swift
//  OdetteNew
//
//  Created by Marina Huber on 18/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import AlamofireImage



class WaterfallViewController: UIViewController {
    
    
    @IBOutlet weak var noFavMoodboard: UILabel!
    @IBOutlet weak var lblEmptyState: UILabel?
    var collectionView: UICollectionView!
    var layout = CollectionViewWaterfallLayout()
    var images = Array<Image>()

    
//MARK: - UIViewController LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = Colors.lightGray
        
        switch UIDevice().userInterfaceIdiom {
        case UIUserInterfaceIdiom.pad:
            layout.sectionInset = UIEdgeInsets(top: view.frame.minY - view.frame.minY + 20,
                                               left: view.frame.minX - view.frame.minX + 30,
                                               bottom: view.frame.maxY - view.frame.maxY + 40,
                                               right: view.frame.maxX - view.frame.maxX + 30)
            layout.minimumInteritemSpacing == 20
            layout.minimumColumnSpacing = 20

        default:
            layout.sectionInset = UIEdgeInsets(top: view.frame.minY - view.frame.minY + 10,
                                               left: view.frame.minX - view.frame.minX + 20,
                                               bottom: view.frame.maxY - view.frame.maxY + 40,
                                               right: view.frame.maxX - view.frame.maxX + 20)
            layout.minimumInteritemSpacing = 10

        }
            collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        //if collectionView is nil do not proceed with it
        guard collectionView != nil else {
            
            return
        }
        switch UIDevice().userInterfaceIdiom {
        case UIUserInterfaceIdiom.pad:
            layout.columnCount = 3
        default:
            layout.columnCount = 1
        }
        self.collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView)

        
    }
    

    
    
    func reloadUI() {
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.collectionView.reloadData()
            self.collectionView.isHidden = (self.images.count == 0)
            self.lblEmptyState?.isHidden = !self.collectionView.isHidden
        })
        
    }

    
}




//MARK: - UICollectionView DataSource

extension WaterfallViewController: UICollectionViewDelegate, UICollectionViewDataSource {
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        collectionView.isHidden = (images.count == 0)
        noFavMoodboard?.isHidden = !collectionView.isHidden
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let odetteImage = images[indexPath.row]
        cell.odetteImageCell = odetteImage
        cell.configureCellWithType(.default)
        
        
        
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
        cell.alpha = 1
            }, completion: nil)
    }
    
    
}




//MARK: - UICollectionViewWaterfallLayout Delegate

extension WaterfallViewController:  CollectionViewWaterfallLayoutDelegate {

    
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let image = images[indexPath.row]
        return image.dimensions?.thumb ?? CGSize.zero
    }
    
   
    
}









