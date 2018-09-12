//
//  MoodboardVC.swift
//  OdetteNew
//
//  Created by Marina Huber on 21/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

protocol GetSelectedItems {
    //here we passing items to the AddMoodboard function. Items to add markes with isSelected = true, items to remove -> isSelcted = false
    var updatedSelectedItems: ((Array<Image>) -> ())? { set get }
}

class MoodboardAddVC: UIViewController {

    var favoritesVC: GetSelectedItems?
    var cameraVC: GetSelectedItems?
    
    
    let maximumCameraAllowed = 1
    
    @IBOutlet weak var constrleadingFavImages: NSLayoutConstraint!
    @IBOutlet weak var viewFavImages: UIView!
    @IBOutlet weak var viewCameraImages: UIView!
    @IBOutlet weak var constrleadingCameraImages: NSLayoutConstraint!
    
   // @IBOutlet weak var noFavorites: UILabel!
    @IBOutlet weak var numberSelection: UILabel!
    @IBOutlet weak var cameraNumberSelection: UILabel!
    @IBOutlet weak var heartFavorites: UIButton!
    @IBOutlet weak var btnCameraImages: UIButton!
    
    
    var itemsFavorite: Array<Image> = [] {
        didSet {
            self.numberSelection.text = "\(itemsFavorite.filter{ $0.isSelected == true}.count)/\(DataManager.getFavoriteItems().count)"
        }
    }
    
    var itemsCamera: Array<Image> = [] {
        didSet {
            self.cameraNumberSelection.text = "\(itemsCamera.count)/\(maximumCameraAllowed)"
        }
    }
    
    var dismissBlock: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show by default Favorites
        self.viewFavImages.isHidden = false

        //hide by default Camera
    
        self.viewCameraImages.isHidden = true
        self.heartFavorites.isSelected = true

    }
    

    
    func saveImagesToMoodboard(_ items: Array<Image>) {

        _ = items.map {
            //save to the moodboard selected items, remove unselected
            let selected = $0.isSelected ?? false
            let alreadyOnMoodBoard = $0.onMoodBoard
            if (selected != alreadyOnMoodBoard) {
                $0.addToMoodBoard(selected)
            }
        }
        
    }
    

//MARK: - Actions
    
    @IBAction func dismiss(_ sender: UIButton) {

        dismissBlock?()
        
      }
  

    @IBAction func addToMoodboard(_ sender: AnyObject) {

        print ("Added from favorites: \(itemsFavorite.count)")
        print ("Added from camera: \(itemsCamera.count)")
        
        
        _ = itemsCamera.map {
            $0.addToMoodBoard(true)
        }
        
        saveImagesToMoodboard(itemsFavorite)

        dismissBlock?()

    }

    
    @IBAction func openFav(_ sender: UIButton) {
        openAddFavorites()
    
    }
    
    
    @IBAction func openCamera(_ sender: UIButton) {
        openAddCameraImages()
    }
    
    
//TODO: open favorites by default
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    
            
            openAddFavorites()
        }
    
    
    
    //MARK: - Navigation
    
    func openAddFavorites() {

        guard viewFavImages.isHidden == true else {
            return
        }
         let w = self.view.frame.width
        self.constrleadingFavImages.constant = -w
        self.viewFavImages.isHidden = false

        self.view.layoutIfNeeded()
        
        self.constrleadingFavImages.constant = 0
        self.constrleadingCameraImages.constant = w
        
        UIView.animate(withDuration: 0.3, animations: {
            
        self.view.layoutIfNeeded()
            
            }, completion: {
                completed in
        
                self.btnCameraImages.isSelected = false
                self.heartFavorites.isSelected = true
                self.viewCameraImages.isHidden = true

                
        })
        
        
        

    }
    
    
    func openAddCameraImages() {
        
        guard viewCameraImages.isHidden == true else {
            return
        }

        let w = self.view.frame.width
        self.constrleadingCameraImages.constant = w
        self.viewCameraImages.isHidden = false

        
        self.view.layoutIfNeeded()
        
        self.constrleadingFavImages.constant = -w
        self.constrleadingCameraImages.constant = 0
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
            
            }, completion: {
                completed in
                
                self.btnCameraImages.isSelected = true
                self.heartFavorites.isSelected = false
                self.viewFavImages.isHidden = true
                
        })

        
    
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "embedFavorites") {
            favoritesVC = segue.destination as? GetSelectedItems
            
            favoritesVC?.updatedSelectedItems = {
                updatedItems in
                
                self.itemsFavorite = updatedItems
                
            }
        }
        
        if (segue.identifier == "embedCameraImages") {
            cameraVC = segue.destination as? GetSelectedItems
            cameraVC?.updatedSelectedItems = {
                updatedItems in
                
                self.itemsCamera = updatedItems
                
                
            }
            
        }

    }
    
    

}



