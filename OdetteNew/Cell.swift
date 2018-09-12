//
//  Cell.swift
//  OdetteNew
//
//  Created by Marina Huber on 26/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import AlamofireImage



enum CellType: Int {
    case `default` = 0
    case details = 1
    case favorites = 2
    case addMoodBoardImages = 3
}

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var acivity: UIActivityIndicatorView!
    @IBOutlet weak var FavoritesBtn: UIButton!
    @IBOutlet weak var selectedMoodboard: UIImageView!
    @IBOutlet weak var deleteFavorites: UIButton!
    @IBOutlet weak var whiteMask: UIView!
    var popOver:UIPopoverController?

    
    
    var mode: CellType?
    
    //closure for cell deletion
    var deleteBlock: (() -> ())?
    var likeBlock: (() -> ())?
    
    
    var odetteImageCell: Image? {
        didSet (oldValue) {
            
            if let urlString = odetteImageCell?.getURL(.thumb), let url = APIRouter.staticImage(urlString).URLRequest.url {
                
                self.imageCell.af_setImage(
                    withURL:url, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.4), runImageTransitionIfCached: false, completion: nil)
                
            }
            
            
            
//            if let url = odetteImageCell?.getURL(.Thumb) {
//                DataManager.getImage(url, completionHandler: {
//                    imageURL, image, error in
//                    
////                    if (imageURL == url && image != self.imageCell.image) {
//                    dispatch_async(dispatch_get_main_queue(), {
////                        self.alpha = 0
//                        self.imageCell.image = image
////                        UIView.animateKeyframesWithDuration(0.4, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: {
////                            self.alpha = 1.0
////                            }, completion: nil)
//                       })
////                    }
//                })
//            }
            self.FavoritesBtn.isSelected = odetteImageCell?.favorite ?? false
        }
    }
    
    @IBOutlet weak var imageCell: UIImageView!

    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//    }
//   
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    
//    }
//  
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.imageCell.image = nil
    }
    
 //TODO: delete these
    override var isSelected: Bool {
        didSet {
//            switch mode {
//            case .Some(.AddMoodBoardImages):
//                print ("\(self.odetteImageCell!.imageName) = \(selected)")
//                
//                 dispatch_async(dispatch_get_main_queue()) {
//                    
//                }
//                
//            default:
//                break
//            }
            
         }
    }

    override var isHighlighted: Bool {
        didSet {
        }
    }

    
    
    func configureCellWithType (_ cellType: CellType) {
        
        self.mode = cellType
        
        switch cellType {
            
        case .favorites:
            
            self.deleteFavorites.isHidden = false
            self.selectedMoodboard.isHidden = true
            self.FavoritesBtn.isHidden = true
            self.contentView.alpha = 1
            self.whiteMask.isHidden = true
            
        case .details:
            self.deleteFavorites.isHidden = true
            self.selectedMoodboard.isHidden = true
            self.FavoritesBtn.isHidden = false
            self.FavoritesBtn.isSelected = odetteImageCell?.favorite ?? false
            self.contentView.alpha = 1
            self.whiteMask.isHidden = true
            
        case .addMoodBoardImages:
            self.deleteFavorites.isHidden = true
            self.FavoritesBtn.isHidden = true
            self.selectedMoodboard.isHidden = !self.isSelected ?? true
            self.whiteMask.isHidden = !self.isSelected ?? false
            
        default:
            self.deleteFavorites.isHidden = true
            self.selectedMoodboard.isHidden = true
            self.FavoritesBtn.isHidden = true
            self.contentView.alpha = 1
            self.whiteMask.isHidden = true
            
        }
        
        
    }
    
    
    @IBAction func deleteFav(_ sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.deleteBlock?()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            
            self.popOver = UIPopoverController(contentViewController: optionMenu)
            self.popOver?.present(from: deleteFavorites.frame, in: self, permittedArrowDirections: UIPopoverArrowDirection.up, animated: true)
            
        } else {
                alertWindow.rootViewController?.present(optionMenu, animated: true, completion: nil)            
        }
        
       

       
    }
    
 
    @IBAction func likeBttn(_ sender: UIButton) {

            self.likeBlock?()
    
   }
    
    
    
    
}
