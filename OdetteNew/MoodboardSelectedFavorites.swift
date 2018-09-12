//
//  MoodboardSelectedFavorites.swift
//  OdetteNew
//
//  Created by Marina Huber on 22/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit


//MARK: - Equatable for Image struct



class MoodboardSelectedFavorites: WaterfallViewController, GetSelectedItems  {
    

    var updatedSelectedItems: ((Array<Image>) -> ())?
    
//MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets (top: 0, left: 0, bottom: 85, right: 0)
        collectionView.allowsMultipleSelection = true
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = Colors.lightGray
        images = DataManager.getFavoriteItems().map {
            var img = $0
            img.isSelected = $0.onMoodBoard
            return img
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
        reloadUI()

        
    }
    
    
    
    override func reloadUI() {
        super.reloadUI()
        
        updatedSelectedItems?(images.filter { $0.isSelected == true })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isPad = UIDevice().userInterfaceIdiom  == .pad
        noFavMoodboard.font = isPad ? UIFont(name: "Servetica-Thin", size: 36) : UIFont(name: "Servetica-Thin", size: 20)
        
    
    print ("On moodboard: \(DataManager.getMoodBoardItems().map{ $0.imageMoodboard.imageName })")
        
    }
    
    

//MARK: UICollectionView DataSource and Delegate
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let image = images[indexPath.row]
        
        if (image.isSelected == true) {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        }
        
        cell.odetteImageCell = image
        cell.configureCellWithType(.addMoodBoardImages)

        return cell
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {

        images[indexPath.row].isSelected = true
        collectionView.reloadItems(at: [indexPath])
        updatedSelectedItems?(images.filter {
            $0.isSelected == true  })
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: IndexPath) {
        
        images[indexPath.row].isSelected = false
        collectionView.reloadItems(at: [indexPath])
        updatedSelectedItems?(images)
    
   
    }

}



