//
//  FavoritesVC.swift
//  OdetteNew
//
//  Created by Marina Huber on 06/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit


class FavoritesVC: WaterfallViewController {

    var containerDelegate: ContainerDelegate?

    @IBOutlet weak var noImages: UILabel!
    
//MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets (top: 0, left: 0, bottom: 35, right: 0)
        lblEmptyState?.isHidden = true
        self.edgesForExtendedLayout = UIRectEdge()
        self.collectionView.contentSize = CGSize(width: view.frame.size.width,height: view.frame.size.height + 200)
        collectionView.backgroundColor = Colors.lightGray

        self.images = DataManager.getFavoriteItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isPad = UIDevice().userInterfaceIdiom  == .pad
        noImages.font = isPad ? UIFont(name: "Servetica-Thin", size: 36) : UIFont(name: "Servetica-Thin", size: 18)
        
        reloadUI()
    }


 

//MARK: - CollectionView Delegate
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.odetteImageCell = images[indexPath.row]
        
        cell.configureCellWithType(.favorites)

        cell.deleteBlock = {
            cell.odetteImageCell?.favorite = false
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
                self.images.remove(at: indexPath.item)
                }, completion: {
                    (finished: Bool) in
                    self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            })
            
        
        }
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        //to pass view image to PERFORMSEGUE
        performSegue(withIdentifier: "segueDetail", sender: indexPath)
        
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "segueDetail") {
            
            let ip = sender as! IndexPath
            let image = images[ip.row]
            let vc = segue.destination as! DetailViewController
            vc.collectionId = image.collectionId
            
        }
    
        }
    
    
    
    
}

