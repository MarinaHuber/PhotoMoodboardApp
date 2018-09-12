//
//  ViewController.swift
//  MenuControllerVC
//
//  Created by Marina Huber on 25/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


@objc
protocol ContainerDelegate {
    @objc optional func switchSearch()
    @objc optional func updateTitle(_ title: String?, isSearch: Bool)
    @objc optional func enableNavIcons(_ enable: Bool)
    @objc optional func updateSideMenus()

}

class ContainerViewController: UIViewController, MenuControllerDelegate, ContainerDelegate {
    
    @IBAction func actnCleanSearch(_ sender: AnyObject) {
    
        updateTitle(nil, isSearch: true)
        searchVC.resetSearch()
    }
    var logoView = UIImageView()
    var titleBtnView = UIView()
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var actnOpenSearch: UIBarButtonItem!
    
    
    var openTableBlock: (() -> ())?
    var currentVC: UIViewController?
  //  var btnLeft: UIBarButtonItem!
    
    
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!

    var addButton: UIBarButtonItem!
    var shareButton: UIBarButtonItem!
    
    var menuVC: MenuVCTableViewController!
    var searchVC: SearchViewController!
    
    static let MENU_WIDTH_PAD: CGFloat = 250.0
    static let MENU_WIDTH_PHONE: CGFloat = 240.0
    
    
    let defaultMenuItemNumber = 0
    
    let menuWidth: CGFloat = (UIDevice().userInterfaceIdiom == .pad) ? MENU_WIDTH_PAD : MENU_WIDTH_PHONE
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        menuVC = storyBoard.instantiateViewController(withIdentifier: "menu") as! MenuVCTableViewController
        menuVC.view.frame = CGRect(x: self.view.bounds.width, y: 0, width: menuWidth, height: self.view.frame.size.height)
        menuVC.menuControllerDelegate = self
        self.view.addSubview(menuVC.view)
        
        searchVC = storyBoard.instantiateViewController(withIdentifier: "menuSearch") as! SearchViewController
        searchVC.containerDelegate = self
        searchVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.size.height)
        self.view.addSubview(self.searchVC.view)
    
        if let defaultStoryBoardID = menuVC.menuItems1[defaultMenuItemNumber].stopryboardID {
            switchVC(defaultStoryBoardID)
            updateTitle(menuVC.menuItems1[defaultMenuItemNumber].title, isSearch: false)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext

        navigationController?.isNavigationBarHidden = false
        navigationController?.delegate = self
        btnMenu.tintColor = UIColor.black
        setNavBarUI()
        
        
        let isPad = UIDevice().userInterfaceIdiom  == .pad
        logoView = isPad ? UIImageView(image: UIImage(named: "logo_cNew")) : UIImageView(image: UIImage(named: "logo@2x_iPad"))
        logoView.frame = CGRect(x: 40, y: 10, width: navigationController!.navigationBar.frame.size.width - 110 - 110, height: navigationController!.navigationBar.frame.size.height - 74)
        logoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationItem.titleView = logoView
        logoView.contentMode = .scaleAspectFit
        
    }
    
    func setNavBarUI() {

        
        //navigationItem.rightBarButtonItems = [btnMenu] //leave only this line

       
    }
    
    
    
    func enableNavIcons(_ enable: Bool) {
        
        navigationController?.navigationBar.tintColor = enable ? Colors.odetteTitle : UIColor.lightGray
        
        navigationItem.rightBarButtonItem?.isEnabled = enable
        navigationItem.leftBarButtonItems?.last?.isEnabled = enable
        btnMenu.isEnabled = enable
        btnSearch.isEnabled = enable
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
    }
    
    
    
    func didSelectMenu(_ menu: MenuItem?) {
        
    
        updateTitle(menu?.title, isSearch: false)

        if let segID = menu?.stopryboardID {
            switchVC(segID)
            presentedViewController?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func switchVC (_ vcStoryboardID: String) {
        
        
        navigationItem.leftBarButtonItem = nil

        //handle special case
        if vcStoryboardID == StoryBoardIDs.Conceptstore.rawValue  {
        
            let url:URL? = URL(string: "http://www.blumcollectionconceptstore.com/")
            UIApplication.shared.openURL(url!)
             return
        }
        
        if let cvc = currentVC {
           cvc.removeFromParentViewController()
           cvc.view.removeFromSuperview()
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        currentVC = storyBoard.instantiateViewController(withIdentifier: vcStoryboardID)
        
        //at this spoint currentVC is viewcontroller that you are going to show according to StoryBoardID
        
        container.addSubview(self.currentVC?.view ?? UIView())
        currentVC?.view.autoPinEdgesToSuperviewEdges()
        
        
        //customize navigation bar
        
        
        switch vcStoryboardID {
        case StoryBoardIDs.LookBook.rawValue:
            
            btnSearch.isEnabled = true
            btnSearch.tintColor = Colors.odetteTitle
            self.navigationItem.leftBarButtonItem = nil
            
            
            break
            
        case StoryBoardIDs.Favorites.rawValue:
            
            navigationItem.leftBarButtonItem = nil
            btnSearch.isEnabled = false
            btnSearch.tintColor = UIColor.clear
            break
            
            
        case StoryBoardIDs.MoodBoard.rawValue:

            let addButton = UIBarButtonItem(image: UIImage(named: "add.png"), style: .plain, target: currentVC, action: #selector(MoodBoardVC.actnBtnAdd))
            let shareButton = UIBarButtonItem(image: UIImage(named: "icon_share.png"), style: .plain, target: currentVC, action: #selector(MoodBoardVC.share))
            navigationItem.leftBarButtonItems = [addButton, shareButton]
            btnSearch.tintColor = UIColor.clear
            (currentVC as! MoodBoardVC).containerDelegate = self
            
            break
            
          case StoryBoardIDs.About.rawValue:
            
            navigationItem.leftBarButtonItem = nil
            btnSearch.tintColor = UIColor.clear
            
            break
            
         case StoryBoardIDs.Terms.rawValue:
            
            navigationItem.leftBarButtonItem = nil
            btnSearch.tintColor = UIColor.clear
            break
            
        default:
            
            break
            
        }
        
        
        if let _ = currentVC as? MainViewController {
            searchVC.mainVCSearchDelegate = currentVC as! MainViewController
        }
        
        addChildViewController(self.currentVC!)
        
        updateSideMenus()
        
    }
    

    
    
    
    func updateSideMenus() {
        
        if let menuVC_ = menuVC {
            var menuFrame = menuVC_.view.frame
            let viewWidth = view.bounds.width
            let isClosed = (menuFrame.origin.x == -menuWidth)
            menuFrame.origin.x = (isClosed) ? (viewWidth - menuWidth) : viewWidth
            UIView.animate(withDuration: 0.3, animations: {
                menuVC_.view.frame = menuFrame
            })
        }
        
        if let searchVC_ = searchVC {
            var searchFrame = searchVC_.view.frame
            searchFrame.origin.x = -menuWidth
            UIView.animate(withDuration: 0.3, animations: {
                searchVC_.view.frame = searchFrame
            })
            
            
        }
    }
//MARK - ContainerDelegate Methods
    
    
  // Computed property variable
    var searchIsOpen: Bool {
        get {
                let searchFrame = searchVC?.view.frame
                return ((searchFrame?.origin.x == 0) ?? false)
        }
    }
    
    
    var menuIsOpen: Bool {
        get {
            let menuFrame = menuVC?.view.frame
            let viewWidth = view.bounds.width
            return ((menuFrame?.origin.x < viewWidth) ?? false)
 
        }
    }
    
    
    //manage search nemu panel
    func switchSearch() {
        
        if let searchVC_ = searchVC {
            var searchFrame = searchVC_.view.frame
            let isClosed = (searchFrame.origin.x == 0)
            
            // if closed -> origin = SCREEN_WIDTH - MENU_WIDTH, if opened -> origin = viewWidth
            
            if (menuIsOpen) {
                actnOpenMenu(self)
            }
            
            if (!isClosed) {
                searchVC_.reloadUI()
            }
          
            
            searchFrame.origin.x = (isClosed) ? (-menuWidth) : 0
            UIView.animate(withDuration: 0.3, animations: {
                searchVC_.view.frame = searchFrame
            })
          
            
        }

        
    }
    
    
    
   @IBAction func actnOpenMenu(_ sender: AnyObject) {
        
        if let menuVC_ = menuVC {
            
            
            if searchIsOpen {
                switchSearch()
            }
            
            var menuFrame = menuVC_.view.frame
            let viewWidth = view.bounds.width
            let isClosed = (menuFrame.origin.x == viewWidth)
            
            
     // if closed -> origin = SCREEN_WIDTH - MENU_WIDTH, if opened -> origin = viewWidth
            menuFrame.origin.x = (isClosed) ? (viewWidth - menuWidth) : viewWidth
            UIView.animate(withDuration: 0.3, animations: {
            menuVC_.view.frame = menuFrame
            })
           

        }
        
    }
    
    
  
    
    
    @IBAction func actnOpenSereach(_ sender: AnyObject) {
        
        switchSearch()
        
        resignFirstResponder()
        
    }
    
   

     
    
    func dismissTitle() {
        updateTitle(nil, isSearch: true)
        searchVC.resetSearch()
        
        
    }
    
    
    func updateTitle(_ title: String?, isSearch: Bool) {
//**************************************************
// animation for iPad menu titles
//**************************************************


        
            if isSearch {
                
                if let t = title {
                
                titleBtnView = UIView.loadFromNibNamed("SearchTagView")!
                (titleBtnView.viewWithTag(1) as! UILabel).text = t
                (titleBtnView.viewWithTag(1) as! UILabel).sizeToFit()
                
                (titleBtnView.viewWithTag(2) as! UIButton).addTarget(self, action: #selector(ContainerViewController.dismissTitle), for: UIControlEvents.touchUpInside)
                
        
                switch UIDevice().userInterfaceIdiom {
                    case UIUserInterfaceIdiom.pad:
                        let btn = UIBarButtonItem(customView: titleBtnView)
                        navigationItem.leftBarButtonItems = [btn]

                case UIUserInterfaceIdiom.phone:

                    let btn = UIBarButtonItem(customView: titleBtnView)
                    navigationItem.leftBarButtonItems = [btn]
                        navigationItem.titleView = titleBtnView
           
                default: break
                    
                    }
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.titleBtnView.alpha = 0
                        }, completion: {
                            completed in
                            
                    
                            self.titleBtnView.removeFromSuperview()
                            self.titleBtnView.alpha = 1
                            self.navigationItem.leftBarButtonItems = nil


                            let isPad = UIDevice().userInterfaceIdiom  == .pad
                            self.logoView = isPad ? UIImageView(image: UIImage(named: "logo_cNew")) : UIImageView(image: UIImage(named: "logo@2x_iPad"))
							
                            self.logoView.frame = CGRect(x: 40, y: 10, width: self.navigationController!.navigationBar.frame.size.width - 110 - 110, height: self.navigationController!.navigationBar.frame.size.height - 74)
                            self.logoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            self.navigationItem.titleView = self.logoView
                            self.logoView.contentMode = .scaleAspectFit
   
                    })
                    
                }
                
            } else {
                
                if let t = title {
                    navigationItem.titleView = nil
                    self.title = t
                    
                } else {
                    let isPad = UIDevice().userInterfaceIdiom  == .pad
                    logoView = isPad ? UIImageView(image: UIImage(named: "logo_cNew")) : UIImageView(image: UIImage(named: "logo@2x_iPad"))
					
                    logoView.frame = CGRect(x: 40, y: 10, width: navigationController!.navigationBar.frame.size.width - 110 - 110, height: navigationController!.navigationBar.frame.size.height - 74)
                    logoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    navigationItem.titleView = logoView
                    logoView.contentMode = .scaleAspectFit
                    
                    
                }
            }
        
        }
    
}





// ********************************************************
// setting delegate here orientation for locked iPhone/iPad from First Launch also
// ********************************************************

extension ContainerViewController: UINavigationControllerDelegate {

}




