//
//  ShoppingCartViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 11/14/20.
//

import UIKit

class ShoppingCartViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuButton: GroceryListMenuButton!
    
    static var dummyFood : [String] = ["Doritos", "Milk", "Steak"]
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        let width = collectionView.frame.size.width * 0.92 
        let height = collectionView.frame.size.height * 0.30
        layout.itemSize = CGSize(width: width, height: height)
        
        // Configure the search bar
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor.white
        
        filteredData = ShoppingCartViewController.dummyFood
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
        
        cell.nameLabel.text = filteredData[indexPath.row]
        
        
        // TODO : Move this logic into the grocery cell or make another image view
        cell.groceryItemPicture.layer.cornerRadius = 15
        cell.groceryItemPicture.clipsToBounds = true
        cell.groceryItemPicture.layer.masksToBounds = true
        cell.groceryItemPicture.layer.shadowRadius = 15
        
        return cell
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? ShoppingCartViewController.dummyFood : ShoppingCartViewController.dummyFood.filter { (item: String) -> Bool in
                    // If dataItem matches the searchText, return true to include it
                    return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
        
        collectionView.reloadData()
    }
    @IBAction func sendGroceryItems(_ sender: Any) {
       
    }
    
    @objc func loadList(notification: NSNotification){
     filteredData = ShoppingCartViewController.dummyFood
     collectionView.reloadData()
    }
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}


