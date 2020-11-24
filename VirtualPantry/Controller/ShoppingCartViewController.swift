//
//  ShoppingCartViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 11/14/20.
//

import UIKit

class ShoppingCartViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height * 0.30
        layout.itemSize = CGSize(width: width, height: height)
        
        // Configure the search bar
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor.white
       
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
        
        // TODO : Move this logic into the grocery cell or make another image view
        cell.groceryItemPicture.layer.cornerRadius = 15
        cell.groceryItemPicture.clipsToBounds = true
        cell.groceryItemPicture.layer.masksToBounds = false
        cell.groceryItemPicture.layer.shadowRadius = 15
        
        return cell
    }
}


