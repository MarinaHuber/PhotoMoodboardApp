//
//  ViewController+UIActivityIndicator.swift
//  OdetteNew
//
//  Created by Marina Huber on 30/06/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit


extension UIViewController {
    
    var activityIndicatorTag: Int { return 999999 }
    
    
    
    func startActivityIndicator(
        _ style: UIActivityIndicatorViewStyle = .gray,
        location: CGPoint? = nil) {
        
        //Set the position - defaults to `center` if no`location`
        
        //argument is provided
        
        let loc = location ?? self.view.center
        
        //Ensure the UI is updated from the main thread
        
        //in case this method is called from a closure
        
        DispatchQueue.main.async(execute: {
            
            //Create the activity indicator
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            //Add the tag so we can find the view in order to remove it later
            
            activityIndicator.tag = self.activityIndicatorTag
            //Set the location
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);

            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            //Start animating and add the view
            
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        })
    }
    
    
    
    func stopActivityIndicator() {
        
        //Again, we need to ensure the UI is updated from the main thread!
        
        DispatchQueue.main.async(execute: {
            //Here we find the `UIActivityIndicatorView` and remove it from the view
            
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        })
    }
    
    
    
    
}
