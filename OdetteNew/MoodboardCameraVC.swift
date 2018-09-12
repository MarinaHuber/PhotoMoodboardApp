//
//  MoodboardCameraVC.swift
//  OdetteNew
//
//  Created by Marina Huber on 22/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

class MoodboardCameraVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, GetSelectedItems  {
    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var camera: UIImageView!
    var popOver:UIPopoverController?
    var updatedSelectedItems: ((Array<Image>) -> ())?
    
    @IBOutlet weak var selectText: UILabel!
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isPad = UIDevice().userInterfaceIdiom  == .pad
        selectText
            .font = isPad ? UIFont(name: "Servetica-Thin", size: 36) : UIFont(name: "Servetica-Thin", size: 22)
        btnAdd.layer.borderColor = UIColor.gray.cgColor
        btnAdd.layer.cornerRadius = btnAdd.frame.width / 2.0
        btnAdd.layer.borderWidth = 1.0
        
        view.backgroundColor = Colors.lightGray
        reloadUI()
        hideImage(camera.image == nil, onCompletion: nil)
        

    }
    
    //testtttt
    
    func hideLabel() {
        
    }
    
    func reloadUI() {
        
        if (camera.image != nil) {
            
            let image = Image(image: camera.image!)
            DataManager.saveImage(camera.image!, name: image.getURL(ImageSize.original))
            self.updatedSelectedItems?([image])
            
        } else {
            self.updatedSelectedItems?([])
        }
        
    }
    
    func hideImage(_ hide: Bool, onCompletion: (() -> ())?) {
        
        guard hide != self.camera.isHidden else {
            return
        }
        
        let currentlyHidden = self.camera.isHidden
        
        self.delete.alpha = currentlyHidden ? 0 : 1
        self.camera.alpha = currentlyHidden ? 0 : 1
        
        self.delete.isHidden = false
        self.camera.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
        
            self.delete.alpha = hide ? 0 : 1
            self.camera.alpha = hide ? 0 : 1
            
            }, completion: {
                completed in

                self.delete.isHidden = hide
                self.camera.isHidden = hide
                onCompletion?()
                
        })
        
    }
    
    
    func restoreSelection() {
        
    }
    
    
   //MARK: PickerView Delegate Methods
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.navigationBar.isTranslucent = false
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                
                self.popOver = UIPopoverController(contentViewController: picker)
                self.popOver?.present(from: btnAdd.frame, in: view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
                
            } else {
                present(picker, animated: true, completion: nil)
                    
            }
        }
    }
        
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])    {
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            camera.image = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            camera.image = possibleImage
        } else {
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(camera.image!, 80) {
            try? jpegData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            popOver?.dismiss(animated: true)

        } else {
            picker.dismiss(animated: true, completion: nil)
        }
        
        
        hideImage(camera.image == nil, onCompletion: nil)
        reloadUI()
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            popOver?.dismiss(animated: true)
            
        } else {
            picker.dismiss(animated: true, completion: nil)
        }

        hideImage(camera.image == nil, onCompletion: nil)
        reloadUI()
    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError
        error: NSErrorPointer?, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
        }
    }
    
 
    
    @IBAction func deleteCamera(_ sender: AnyObject) {
        
        self.hideImage(true, onCompletion: {
            self.camera.image = nil
            self.reloadUI()
        })
     }
    
    
    @IBAction func openCamera(_ sender: AnyObject) {
        openGallery()
    }
    
    
}

