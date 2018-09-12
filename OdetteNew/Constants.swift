//
//  Constants.swift
//  OdetteNew
//
//  Created by Marina Huber on 21/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

struct Colors {
    
    static let lightGray = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    static let odetteGrey = UIColor(red: 134.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1.0)
    static let odetteBrown = UIColor(red: 133.0/255.0, green: 102.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    static let odetteTitle = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let odetteRed = UIColor(red: 160.0/255.0, green: 0.0, blue: 30.0/255.0, alpha: 1.0)
    
}

struct Font {
    static let iPadText = UIFont(name: "Servetica-Thin", size: 23)
    static let iPhoneText = UIFont(name: "Servetica-Thin", size: 20)
    
    
    static func mainFontWithSize(_ size: CGFloat) -> UIFont?  {
        return UIFont(name: "Servetica-Thin", size: size)
    }

    static let iPadMenuTitle = Font.mainFontWithSize(20)
}
