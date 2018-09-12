//
//  MoodboardCell.swift
//  OdetteNew
//
//  Created by Marina Huber on 15/06/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

class MoodboardCell: Cell {
    
    
    @IBOutlet weak var checked: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var selected: Bool {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.imageCell.layer.opacity = self.selected ? 0.5 : 1.0
                
            })
            
        }
    }


}
