//
// Header.swift
//  OdetteNew
//
//  Created by Marina Huber on 26/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

class Header: UIView {

    @IBOutlet var head: UIView!
 
    required init?(coder aDecoder: NSCoder) {
        //SET PROPERTIES HERE
        super.init(coder: aDecoder)
        UINib(nibName: "Header", bundle: nil).instantiateWithOwner(self, options: nil)
        
        UIView.animateWithDuration(1.3, delay: 0, options: .CurveEaseIn, animations: {
            self.addSubview(self.head)
            self.head.frame = self.bounds
            
            }, completion: nil)
        
    }
    
    
}
