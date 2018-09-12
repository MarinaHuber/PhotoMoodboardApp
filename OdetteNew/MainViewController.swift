//
//  MainViewController.swift
//  OdetteNew
//
//  Created by Marina Huber on 24/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


//MARK: SearchVC logic
protocol MainScreenSearchProtocol {
    func gotTagSearchUpdate(_ tag: String?)
}


class MainViewController: WaterfallViewController {

    @IBOutlet weak var shadow: UIImageView!
    
    @IBOutlet weak var acivityMain: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
//MARK: - UIViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = Colors.lightGray
        self.view.bringSubview(toFront: shadow)
        searchImages(nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext
        refreshControl.addTarget(self, action: #selector(MainViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        collectionView.addSubview(refreshControl)
        
        UIView.animate(withDuration: 1.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
            }, completion: nil)

        collectionView.contentInset = UIEdgeInsets (top: 0, left: 0, bottom: 35, right: 0)
        lblEmptyState?.font = UIFont(name: "Servetica-Thin", size: 22)
        lblEmptyState?.isHidden = true
    }
    override func awakeFromNib() {
       acivityMain?.startAnimating()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    func refresh(_ sender:AnyObject)
    {
       DispatchQueue.main.async(execute: {
        self.collectionView.reloadData()
        })
        refreshControl.endRefreshing()
    }
    
    
    func searchImages(_ tag: String?) {
        if let t = tag {
            NetworkManager.getImagesByTag(t, completionHandler: {
                error, imagesLoaded in
                self.images = imagesLoaded ?? []
                self.reloadUI()
                self.acivityMain.isHidden = true

            })
            
        } else {
            NetworkManager.getCollections{
                error, collections in
            
                self.images = collections?.flatMap {
                    $0.cover
                } ?? []
                self.reloadUI()
            }
        }
    }
     


//MARK: - Overide CollectionView Delegate Methods
    
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.isHidden = (images.count == 0)
        self.acivityMain.hidesWhenStopped = !collectionView.isHidden
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        //to pass view image PERFORMSEGUE
        performSegue(withIdentifier: "segueDetail", sender: indexPath)
    }
    
    
    // this function is called after didSelectRowAtIndex
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueDetail") {
            let ip = sender as! IndexPath
            let image = images[ip.row]
            let vc = segue.destination as! DetailViewController
            vc.collectionId = image.collectionId
            
        }
        
    }
    

}

//MARK: - MainScreenSearchProtocol

extension MainViewController: MainScreenSearchProtocol {
    
    func gotTagSearchUpdate(_ tag: String?) {
        if (tag > "") {
            searchImages(tag)
            title = tag
        } else {
            searchImages(nil)
        }
    }
    
}
