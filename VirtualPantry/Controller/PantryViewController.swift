//
//  PantryViewController.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/27/20.
//

import UIKit
import FirebaseFirestore
class PantryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: PantryMenuButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    static var dummyFood : [String] = []
    static var quantities : [Int] = []
    var filteredData: [String]!
    
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
        //create function which loops through users items
        // Configure the search bar
        searchBar.delegate = self
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor.white
        
        filteredData = PantryViewController.dummyFood
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PantryItemCell", for: indexPath) as! PantryItemCell
        
        // TODO : Move this logic into the grocery cell or make another image view
        let itemID = filteredData[indexPath.row]
        let db = Firestore.firestore()
        let item = db.collection("pantryItems").document(itemID)
        
        item.getDocument { (document, error) in
            if let document = document {
                let property = document.get("name")
                cell.nameLabel.text = (property as! String)
                print(property!)
            } else {
                print("Document does not exist in cache")
            }
        }
    
        cell.currentQuantity = PantryViewController.quantities[indexPath.row]
        cell.pantryItemPicture.layer.cornerRadius = 15
        cell.pantryItemPicture.clipsToBounds = true
        cell.pantryItemPicture.layer.masksToBounds = true
        cell.pantryItemPicture.layer.shadowRadius = 15
        cell.quantityLabel.text = "Quantity: \(PantryViewController.quantities[indexPath.row])"
        cell.setColor()
        
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? PantryViewController.dummyFood : PantryViewController.dummyFood.filter { (item: String) -> Bool in
                    // If dataItem matches the searchText, return true to include it
                    return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }
    
    
    func performSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "goAddItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }

}
