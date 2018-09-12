//
//  DetailViewController.swift
//  OdetteNew
//
//  Created by Marina Huber on 5/25/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import MessageUI
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



class DetailViewController: WaterfallViewController {

    var heavarView: UIView!
    var collectionId: Int?
    var liked: UIBarButtonItem?
    
    @IBOutlet weak var likeBtn: UIBarButtonItem!
    @IBOutlet weak var likeNavigator: UIButton!
    @IBOutlet weak var titleFavorite: UILabel!
    @IBOutlet weak var bar: UINavigationBar!
    @IBOutlet weak var navigator: UIButton!
    var collection: Collection?
    
    
    var likedAll: Bool = false  {
        didSet {
            
            if (likedAll) {
                DataManager.addFavoriteImages(images)
            } else {
                DataManager.removeFavoriteImages(images)
            }
//           self.images =  self.images.map {
//                var t = $0
//                t.favorite = likedAll
//                return t
//            }
            
        }
    }
    
//MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        collectionView.contentInset = UIEdgeInsets (top: 0, left: 0, bottom: -10, right: 0)
        collectionView?.allowsMultipleSelection = true
        collectionView.reloadData()
        collectionView.register(UINib(nibName: "Header", bundle: nil), forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        layout.headerHeight = 168.0
        layout.headerInset = UIEdgeInsets(top: 62.0, left: 0.0, bottom: 0.0, right: 0.0)
        view.bringSubview(toFront: bar)
        bar.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        let statusBar: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBar.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.addSubview(statusBar)

//        

        
    }


    func reloadSections() {
        
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadSections(IndexSet(integer: 0))
            
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        self.collectionView.animateAppearance()
        
        if let colId = collectionId {
            
            NetworkManager.getCollectionByID(colId, completionHandler: {
                error, collection in
                
              //  print ("first item: \(collection?.imageCollection.first?.imageName)")
                
                guard collection != nil else {return}
                self.collection = collection
                self.images = collection?.imageCollection ?? []
              
                self.reloadSections()
                
                
            })
            
        }
        
        
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UICollectionView) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5.0, options: .allowAnimatedContent, animations: {
            self.bar.alpha = 0.6
            
            return
            
            }, completion: { finished in
            

        })  

    }

    
    func scrollViewDidScroll(_ scrollView: UICollectionView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bar.alpha = 0.0
            

        })
        
    }


//MARK: - UICollectionView DataSource and Delegate
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! Header
        headerView.layer.opacity = 0.95
        headerView.lblTitle.text = collection?.data?.title
        
        //headerView.lblTitle.textColor = Colors.odetteTitle
        headerView.descriptionTxt.text = collection?.data?.description
        let isPad = UIDevice().userInterfaceIdiom  == .pad
        headerView.lblTitle.font = isPad ? UIFont(name: "Helvetica", size: 18) : UIFont(name: "Helvetica", size: 17)
        headerView.descriptionTxt.font = isPad ? UIFont(name: "Helvetica", size: 14) : UIFont(name: "Helvetica", size: 12)
        headerView.descriptionTxt.textColor = Colors.odetteTitle
        headerView.storeBtn.titleLabel!.textColor = Colors.odetteRed
        
        headerView.image = collection?.artist


        if (collection?.data?.advice_URL > "") {
            
            headerView.storeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            headerView.storeBtn.titleLabel!.font = UIFont(name: "Helvetica", size: 14)
            let myNormalAttributedTitle = NSAttributedString(string: "MIX & MATCH",
                                                             attributes: [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
            headerView.storeBtn.setAttributedTitle(myNormalAttributedTitle, for: UIControlState())
            headerView.forwardBlock = {
            self.openAdvice()
            }
            
        } else
        
        
        if (collection?.data?.conceptStore_URL > "") {
            
            headerView.storeBtn.titleLabel!.font = UIFont(name: "Helvetica", size: 14)
            let myNormalAttributedTitle = NSAttributedString(string: "SHOP",
                                                             attributes: [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
            headerView.storeBtn.setAttributedTitle(myNormalAttributedTitle, for: UIControlState())
            headerView.storeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            headerView.forwardBlock = {
            self.openStore()
            }
       } else
        
        if (collection?.data?.collection > "") {
            headerView.storeBtn.titleLabel!.font = UIFont(name: "Helvetica", size: 14)
            let myNormalAttributedTitle = NSAttributedString(string: "CONTACT",
                                                             attributes: [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
            headerView.storeBtn.setAttributedTitle(myNormalAttributedTitle, for: UIControlState())
            headerView.storeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            
            headerView.forwardBlock = {
            self.sendEmail()
            }

        }
        
        
        
        return headerView
    }



    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.odetteImageCell = images[indexPath.row]
        cell.configureCellWithType(.details)
        
        
        
        cell.likeBlock = {
            let isSelected = (cell.odetteImageCell?.favorite ?? false)
            cell.odetteImageCell?.favorite = !isSelected
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        self.performSegue(withIdentifier: "customSegue", sender: indexPath)

    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "customSegue") {

			let indexPath = sender as! IndexPath
			let vc = segue.destination as! GalleryViewController

			vc.imagesBig = images
			vc.currentImage = indexPath.row

			//  print("Detail current IMAGE: \(vc.imagesBig[vc.currentImage!].imageName)")

		}
	}










//MARK: - URL redirect functions
    
    func openStore() {
        
        let url:URL? = URL(string: (collection?.data?.conceptStore_URL?.cString)!)
        UIApplication.shared.openURL(url!)
        return
    }
    
    func openAdvice() {
        
        let url:URL? = URL(string: (collection!.data!.advice_URL!.URLString))
        UIApplication.shared.openURL(url!)
        return
    }


    
//MARK: - Actions

    @IBAction func closeDetail(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)


   }

    

    @IBAction func likeAllFavorites(_ sender: UIBarButtonItem) {
        
        self.likedAll = !self.likedAll
        sender.image = self.likedAll ? UIImage(named: "icon_favorites_full") : UIImage(named: "icon_favorites_empty")

        
         DispatchQueue.main.async(execute: {
         
            let visibleCells = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: visibleCells)
         })
    
    }
    
    


}















// MARK: MFMailComposeViewControllerDelegate

extension DetailViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
         var msg = String() 
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            msg = "Canceled"
            print("canceled")
            
        case MFMailComposeResult.failed.rawValue:
            msg = "Failed"
            print("failed")
            
        case MFMailComposeResult.saved.rawValue:
            msg = "Saved"
            print("saved")
            
        case MFMailComposeResult.sent.rawValue:
            msg = "Sent"
            print("sent")
            
        default:
            break
        }
        let mailResuletAlert: UIAlertView = UIAlertView(frame: CGRect(x: 10, y: 170, width: 300, height: 120))
        mailResuletAlert.message = msg
        mailResuletAlert.title = "Message"
        mailResuletAlert.addButton(withTitle: "OK")
        mailResuletAlert.show()
        mailResuletAlert.removeFromSuperview()
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let toRecipents = ["info@blumcollection.com"]
        let emailTitle = collection?.data?.title
        let messageBody = ""
        
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setToRecipients(toRecipents)
        mc.setSubject(emailTitle!)
        mc.setMessageBody(messageBody, isHTML: true)
        return mc
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
   
}


