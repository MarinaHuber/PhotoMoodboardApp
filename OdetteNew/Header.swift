//
//  Header.swift
//  GenericControllers
//
//  Created by Marina Huber on 5/27/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import Foundation
import UIKit


class Header: UICollectionReusableView {
    
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var descriptionTxt: UITextView!
    
    var forwardBlock: (() -> ())?

    
    @IBOutlet var profilePic: UIImageView!
        
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profilePic.image = nil
        storeBtn.titleLabel!.textColor = Colors.odetteRed
        
    }
    
    var image: Image! {
        
        didSet {
            
            self.profilePic.loadImageFromOdetteImage(image, size: ImageSize.thumb)
            
        }
        
    }
    

    
    @IBAction func contactUs(_ sender: UIButton) {
        
        forwardBlock?()

        
    }

    
 

}
