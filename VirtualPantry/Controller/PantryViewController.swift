//
//  PantryViewController.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/27/20.
//

import UIKit


class PantryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: PantryMenuButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dummyFood : [String] = ["Doritos", "Milk", "Steak"]
    var quantities : [Int] = [1,2,3]
    var filteredData: [String]!
    var delegate: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        let width = collectionView.frame.size.width * 0.92
        let height = collectionView.frame.size.height * 0.30
        layout.itemSize = CGSize(width: width, height: height)
        
        // Configure the search bar
        searchBar.delegate = self
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor.white
        filteredData = dummyFood
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PantryItemCell", for: indexPath) as! PantryItemCell
        
        // TODO : Move this logic into the grocery cell or make another image view
        cell.nameLabel.text = filteredData[indexPath.row]
        cell.currentQuantity = quantities[indexPath.row]
        cell.pantryItemPicture.layer.cornerRadius = 15
        cell.pantryItemPicture.clipsToBounds = true
        cell.pantryItemPicture.layer.masksToBounds = true
        cell.pantryItemPicture.layer.shadowRadius = 15
        cell.quantityLabel.text = "Quantity: \(quantities[indexPath.row])"
        cell.setColor()
        
        
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? dummyFood : dummyFood.filter { (item: String) -> Bool in
                    // If dataItem matches the searchText, return true to include it
                    return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }
    
    @IBAction func sendPantryItem(_ sender: Any) {
        print(ShoppingCartViewController.dummyFood)
        ShoppingCartViewController.dummyFood.append("Hello")
        print(ShoppingCartViewController.dummyFood)
        NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
    }
    
    @IBAction func performSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "goAddItem", sender: self)
    }
    
    
}
