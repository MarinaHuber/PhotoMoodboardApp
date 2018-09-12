//
//  TermsVC.swift
//  
//
//  Created by Marina Huber on 06/05/16.
//
//

import UIKit

class TermsVC: UIViewController {
    
    @IBOutlet weak var termsHtml: UIWebView!
    //MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localfilePath = Bundle.main.url(forResource: "terms", withExtension: "html")
        let myRequest = URLRequest(url: localfilePath!)
        termsHtml.loadRequest(myRequest)
        
    }

}
