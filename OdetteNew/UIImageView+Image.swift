//
//  UIImageView+Image.swift
//  OdetteNew
//
//  Created by Eugene Braginets on 28/6/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImageFromOdetteImage (_ odetteImage: Image?, size: ImageSize) {

        
        
                if (odetteImage != nil) {
                    
                    let url = odetteImage!.getURL(size)
        
                    DataManager.getImage(url, completionHandler:  {
                        urlString, imageLoaded, error in

                        DispatchQueue.main.async(execute: {
                            self.image = imageLoaded
                        })
                    })
                    
        }
        
    }
    

    func setImageWithAnimation(_ image: UIImage, completion: (() -> ())?) {
        
        
        guard (image != self.image) else {
            return
        }
        
        DispatchQueue.main.async(execute: {

            UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: UIViewKeyframeAnimationOptions.allowUserInteraction, animations: {
                self.alpha = 0.0
                }, completion: {
                    completed in
                    self.image = image
                    
                    UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: UIViewKeyframeAnimationOptions.allowUserInteraction, animations: {
                        self.alpha = 1.0
                        }, completion: {
                            completed in
                            completion?()
                    })
            })
        })
        
            
        

    }

}

