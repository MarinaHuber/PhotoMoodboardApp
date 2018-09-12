//
//  MoodBoardVC.swift
//  OdetteNew
//
//  Created by Eugene Braginets on 30/6/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import Social
import MessageUI


class MoodBoardVC: UIViewController, UIPopoverPresentationControllerDelegate {


    var containerDelegate: ContainerDelegate?
    var desktopController: MoodboardDesktopVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        desktopController.watermarkBanner.isHidden = true
    }

    
// MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "MoodBoardDesktopVC") {
            desktopController = segue.destination as! MoodboardDesktopVC
        }
        
    }
 



//MARK: - Actions

func actnBtnAdd() {
    
    desktopController.saveOnscreenMoodBoardItems()
    containerDelegate?.enableNavIcons?(false)
    //this closes menu
    containerDelegate?.updateSideMenus?()
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "View 4") as! MoodboardAddVC

    vc.dismissBlock = {
        vc.dismiss(animated: true, completion: nil)
        self.desktopController.reloadImages()
        self.containerDelegate?.enableNavIcons?(true)
    }
    
    self.present(vc, animated: true, completion: nil)
}


func share(_ sender: AnyObject) {
    showActionSheet(sender)
    
}


}

//MARK: - UIMessageMail & Social

extension MoodBoardVC: MFMailComposeViewControllerDelegate {
    
    
    func showActionSheet(_ sender: AnyObject) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil
            , preferredStyle: .actionSheet)
        optionMenu.modalPresentationStyle = .popover
        // 2
        
        let msg = "Check out my moodboard, created with the Odette Blum app!"
        let emailAction = UIAlertAction(title: "Share via Email", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let image = self.makeScreenShot()
            self.setupMail(image!)
            self.desktopController.watermarkBanner.isHidden = true
            print("Emailed")
        })
        // 3
        let facebookAction = UIAlertAction(title: "Share on Facebook", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Share FB")
            self.postFacebook(msg)
            self.desktopController.watermarkBanner.isHidden = true
        })
        // 4
        let shareAction = UIAlertAction(title: "Share on Twitter", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Share Twitter")
            self.postTwitter(msg)
            self.desktopController.watermarkBanner.isHidden = true
        })
        
        // 5
        let odetteAction = UIAlertAction(title: "Send to Odette", style: .default , handler: {
            (alert: UIAlertAction!) -> Void in
            let image = self.makeScreenShot()
            self.setupMailOdette(image!)
            self.desktopController.watermarkBanner.isHidden = true
          

        })
        // 6
        let saveAction = UIAlertAction(title: "Save to camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.screenShotCameraSave()
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        
        
        optionMenu.addAction(emailAction)
        optionMenu.addAction(facebookAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(odetteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            
            let btn = sender as? UIBarButtonItem
            let popOver = UIPopoverController(contentViewController: optionMenu)
            popOver.present(from: btn!, permittedArrowDirections: .up, animated: true)
            
            } else {
            present(optionMenu, animated: true, completion: nil)
        }

        
    }
    
    
    
    
    
    //MARK: - createMoodboard Screenshot
    
    func screenShotCameraSave() {
        
        UIImageWriteToSavedPhotosAlbum(makeScreenShot()!, nil, nil, nil)
        desktopController.watermarkBanner.isHidden = true
        savedImageAlert()
        
    }
    
    
    func makeScreenShot() -> UIImage? {
//****************************************************************************************
// Watermark for iPhone / iPad "moodboard created with blumcolletion app" it is  hugging constraints
//****************************************************************************************
        
        desktopController.watermarkBanner.isHidden = false

        desktopController.watermarkLogo.image = UIImage(named: "logo_watermark")
        desktopController.desktop.bringSubview(toFront: desktopController.watermarkBanner)
        
        
        UIGraphicsBeginImageContextWithOptions(desktopController.desktop.frame.size, view.isOpaque, 0.0)
        desktopController.desktop.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
  
        
    }
    
    func savedImageAlert() {
        
        let alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButton(withTitle: "Ok")
        
        alert.show()
    }
    
    
    func setupMail(_ imageShot: UIImage) {
        if( MFMailComposeViewController.canSendMail() ) {
            
            let image = makeScreenShot()
            
            let toRecipents = [""]
            let emailTitle = "Please look at my moodboard"
            let messageBody = ""
            
            
            let imageShot = UIImageJPEGRepresentation(image!, 1.0)
            UINavigationBar.appearance().barTintColor = UIColor.white
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            
            mc.mailComposeDelegate = self
            
            mc.setToRecipients(toRecipents)
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            
            mc.addAttachmentData(imageShot!, mimeType: "image/jpeg", fileName: "image.jpeg")
            present(mc, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func setupMailOdette(_ imageShot: UIImage) {
        
        if( MFMailComposeViewController.canSendMail() ) {
            
            let image = makeScreenShot()
            
            let toRecipents = ["info@blumcollection.com"]
            let emailTitle = "Please look at my moodboard"
            
            
            let imageShot = UIImageJPEGRepresentation(image!, 1.0)
            UINavigationBar.appearance().barTintColor = UIColor.white
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            
            mc.mailComposeDelegate = self
            
            mc.setToRecipients(toRecipents)
            mc.setSubject(emailTitle)
            
            mc.addAttachmentData(imageShot!, mimeType: "image/jpeg", fileName: "image.jpeg")
            present(mc, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var msg = String()
        
        switch result {
        case MFMailComposeResult.cancelled:
    
            controller.dismiss(animated: true, completion: nil)
            msg = ("canceled")
            desktopController.watermarkBanner.isHidden = true
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed:
            msg = ("failed")
            desktopController.watermarkBanner.isHidden = true
            
        case MFMailComposeResult.saved:
            msg = ("saved")
            desktopController.watermarkBanner.isHidden = true
            
        case MFMailComposeResult.sent:
            msg = ("sent")
            desktopController.watermarkBanner.isHidden = true

        default:
            msg = ("sent")
            desktopController.watermarkBanner.isHidden = true
            
        }
        
        
        let mailResuletAlert: UIAlertView = UIAlertView(frame: CGRect(x: 10, y: 170, width: 300, height: 120))
        desktopController.watermarkBanner.isHidden = true
        mailResuletAlert.message = msg
        mailResuletAlert.title = "Message"
        mailResuletAlert.addButton(withTitle: "OK")
        mailResuletAlert.show()
        mailResuletAlert.removeFromSuperview()
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func postTwitter(_ msg: String) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let TwitterSheet: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            TwitterSheet.setInitialText(msg)
            let image = makeScreenShot()
            TwitterSheet.add(image)
            self.present(TwitterSheet, animated: true, completion: nil)
            
        } else {
            //  desktopController.watermarkBanner.hidden = true
            let alert = UIAlertController(title: "Accounts", message: "Log in to Twitter in your Settings", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                
                
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, width: 2.0, height: 2.0) // this is the center of the screen currently but
                alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                self.present(alert, animated: true, completion: nil)
            }
            
		}
        
    }
    
  
    
    func postFacebook(_ msg: String) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let facebookSheet: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            facebookSheet.setInitialText(msg)
            let image = makeScreenShot()
            facebookSheet.add(image)
            self.present(facebookSheet, animated: true, completion: nil)
            
        } else {
          //  desktopController.watermarkBanner.hidden = true
            let alert = UIAlertController(title: "Accounts", message: "Log in to Facebook in your Settings", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                

            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, width: 2.0, height: 2.0) // this is the center of the screen currently but
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
            self.present(alert, animated: true, completion: nil)
                
            }
            else {
                self.present(alert, animated: true, completion: nil)
            }
        
        }
    }


    
    
    
    
    
}



