//
//  SearchViewController.swift
//  MenuControllerVC
//
//  Created by Marina Huber on 26/04/16.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



extension UIView {
    
    func animateStart(_ duration: TimeInterval, delay: TimeInterval, completion: @escaping ((Bool) -> Void)) {
        
        let originalX = self.frame.origin.x
        self.frame = CGRect(x: -UIScreen.main.bounds.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            
            self.frame = CGRect(x: originalX, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            self.alpha = 1.0
            
            }, completion: completion)
    }

    
    
}


class SearchBar: UITextField {
    
   
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y + 3,
                          width: bounds.size.width, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}


class SearchCell: UITableViewCell {
    
    @IBOutlet weak var searchTitle: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
     searchTitle.textColor = Colors.odetteBrown
     searchTitle.font = UIFont(name: "Servetica-Thin", size: 22)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}



class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    var containerDelegate: ContainerDelegate?
    var mainVCSearchDelegate: MainScreenSearchProtocol?
    var searchResults = Array<Tag>()
    var searchTags = Array<Tag>()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: SearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.clearButtonMode = UITextFieldViewMode.whileEditing
        searchBar.layer.cornerRadius = 5.5
        let font = UIFont(name: "Servetica-Thin", size: 20.5)
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search pictures",
                                       attributes:[NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: font!])

        searchBar.delegate = self
        DataManager.getTags {
            tags in
            self.searchTags = tags ?? []
            self.resetSearch()
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadUI()
        
        
        
        
     }
    
    func reloadUI() {
        
        DispatchQueue.main.async(execute: { () -> Void in

        self.tableView.reloadData()

        let indexPathFirstVisibleRow = self.tableView.indexPathsForVisibleRows?.first?.row ?? 0
                    let visibleInexPaths = self.tableView.indexPathsForVisibleRows
                    
                    _ = visibleInexPaths.map {
                        
                        $0.map {
                            let cell = self.tableView.cellForRow(at: $0)
                            cell?.animateStart(0.8, delay: Double($0.row - indexPathFirstVisibleRow) * 0.03, completion: {
                                completed in
                
                            })
                            
                        }
                        
                        
                    }
            
                })

    }
    
    
    
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return searchResults.count
   }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchCell ?? SearchCell()

        let tag = searchResults[indexPath.row]
        cell.searchTitle.text = tag.name
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tag = searchResults[indexPath.row].name
        containerDelegate?.updateTitle?(tag, isSearch: true) //update title with tag name
        containerDelegate?.switchSearch?() //hide searh menu
        mainVCSearchDelegate?.gotTagSearchUpdate(tag) //send the to main view to update collection view
        searchBar.resignFirstResponder() //close keyboard
        
        
    }
    
    
    
    //MARK: - TextField delegate and listeners
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if (text > "") {
            searchResults = searchTags.filter {
                
                //check name has text containing typed letters
                
                $0.name.lowercased().contains(text!.lowercased())
            }
        } else {
            resetSearch()
        }
        
        
        self.reloadUI()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resetSearch()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        resetSearch()

        return true
    }
    
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print ("text to search: \(textField.text)")
        searchBar.text = ""
        searchBar.resignFirstResponder()
        containerDelegate?.switchSearch?()
        mainVCSearchDelegate?.gotTagSearchUpdate(textField.text)
        
        return true
    }
    

    //MARK: - Logic
    
    
    func resetSearch() {
        
        searchResults = searchTags
        mainVCSearchDelegate?.gotTagSearchUpdate(nil)
        containerDelegate?.updateTitle?(nil, isSearch: true)
        reloadUI()
        }
    
    
    
}
