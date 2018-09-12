//
//  MoodboardItem.swift
//  OdetteNew
//
//  Created by Marina Huber on 29/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import Foundation
import UIKit


struct MoodboardItem: Equatable {
    
    let imageMoodboard: Image!
    var transform = CGAffineTransform.identity
    var zIndex: Int = 0
    
    var isSelected: Bool?
    
    init (image: Image) {
        self.transform = CGAffineTransform.identity
        self.imageMoodboard = image
    }

    init (image: Image, transformMatrix: CGAffineTransform, zIndex: Int) {
        self.transform = transformMatrix
        self.imageMoodboard = image
        self.zIndex = zIndex
    }

    
}


extension MoodboardItem {
    
    func update() {
    
        DataManager.updateMoodBoardItem(self)
        
    }
    
    
    
}


func ==(lhs: MoodboardItem, rhs: MoodboardItem) -> Bool {
    
    return lhs.imageMoodboard == rhs.imageMoodboard &&  lhs.zIndex == rhs.zIndex && CGAffineTransformEqualToTransform(lhs.transform, rhs.transform)
    
}

