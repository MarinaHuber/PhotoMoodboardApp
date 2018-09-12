//
//  AboutMe.swift
//  OdetteNew
//
//  Created by Marina Huber on 06/05/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

class AboutMe: UIViewController {
    
    
    @IBOutlet weak var aboutView: UIWebView!
    
    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL (string: "http://odetteblum-cms.xs2theworld.com/me");
        let requestObj = URLRequest(url: url!);
        aboutView.loadRequest(requestObj);
    }

}
