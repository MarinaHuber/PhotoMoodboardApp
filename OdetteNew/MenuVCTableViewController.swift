//
//  MenuVCTableViewController.swift
//  MenuControllerVC
//
//  Created by Marina Huber on 25/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit

//protocol name and required method in ContainerVC
protocol MenuControllerDelegate {
    
    func didSelectMenu(_ menu: MenuItem?)
    
}


enum StoryBoardIDs: String {
    case LookBook = "View 1"
    case Favorites = "View 2"
    case MoodBoard = "View 3"
    case Conceptstore = "Conceptstore"
    case About = "View 6"
    case Terms = "View 5"
    
    
}

struct MenuItem {
    let title: String?
    let menuItem: String?
    let stopryboardID: String?
    var image: UIImage?
    
}

class MenuVCTableViewController: UIViewController {
    //protocol declaration
    var menuControllerDelegate: MenuControllerDelegate? 
    
    @IBOutlet var table: UITableView!
    var currentItem = String()
    
    //HERE ADD NEW OR MANAGE EXISTING MENU ITEMS
    
    let menuItems1 =
     [MenuItem(title: "Lookbook", menuItem: "Lookbook", stopryboardID: StoryBoardIDs.LookBook.rawValue, image: UIImage(named: "icon_menu_collection")),
      MenuItem(title: "Favorites", menuItem: "Favorites", stopryboardID: StoryBoardIDs.Favorites.rawValue, image: UIImage(named: "icon_menu_favorite")),
      MenuItem(title: "Moodboard", menuItem: "Create moodboard", stopryboardID: StoryBoardIDs.MoodBoard.rawValue, image: UIImage(named: "icon_menu_moodboard")),
      MenuItem(title: "Conceptstore", menuItem: "Conceptstore", stopryboardID: StoryBoardIDs.Conceptstore.rawValue, image: UIImage(named: "bag4")),
      MenuItem(title: "Me", menuItem: "Me", stopryboardID: StoryBoardIDs.About.rawValue, image: UIImage(named: "icon_menu_about_odette")),
      MenuItem(title: "Terms and Conditions", menuItem: "Terms & Conditions", stopryboardID: StoryBoardIDs.Terms.rawValue, image: UIImage(named: "icon_menu_terms_pressed"))]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        table.backgroundColor = UIColor.clear
        
    }

   }



class MenuCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleCell: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        titleCell.textColor = selected ? Colors.odetteTitle : Colors.odetteBrown
        titleCell.font = UIFont(name: "Servetica-Thin", size: 20.6)
        imageCell.image = imageCell.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageCell.tintColor = selected ? Colors.odetteTitle : Colors.odetteBrown
   

// to find Fonts in app
//                for family: String in UIFont.familyNames()
//                {
//                    print("\(family)")
//                    for names: String in UIFont.fontNamesForFamilyName(family)
//                    {
//                        print("== \(names)")
//                    }
//                }
//        
        


    }
    
}


extension MenuVCTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems1.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuCell ?? MenuCell()
        cell.backgroundColor = UIColor.clear
        cell.titleCell.text = menuItems1[indexPath.row].menuItem
        cell.imageCell.image = menuItems1[indexPath.row].image

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let menuItem = menuItems1[indexPath.row]
        menuControllerDelegate?.didSelectMenu(menuItem)

        
        
        
    }
    
}


