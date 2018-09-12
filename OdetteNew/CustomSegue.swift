//
//  CustomSegue.swift
//  DetailFinalOdette
//
//  Created by Marina Huber on 31/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform()
    {
        let sourceVC = self.source
        let destinationVC = self.destination as! GalleryViewController
        
        let sourceView = self.source.view
        let destView = self.destination.view
        
        
        destinationVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
//        sourceView.addSubview(destView)

// Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(destView!, aboveSubview: sourceView!)
        

        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            destinationVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }) {
            finished in
            
            sourceVC.present(destinationVC, animated: false, completion: nil)
            
            }
    }

}

class CustomSegueDismiss: UIStoryboardSegue {
    
}
