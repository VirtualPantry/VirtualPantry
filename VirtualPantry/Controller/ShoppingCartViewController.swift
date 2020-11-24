//
//  ShoppingCartViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 11/14/20.
//

import UIKit

class ShoppingCartViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 15
        
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height * 0.30
        layout.itemSize = CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
        
        
        // TODO : Move this logic into the grocery cell or make another image view
        cell.groceryItemPicture.layer.cornerRadius = 15
        cell.groceryItemPicture.clipsToBounds = true
        cell.groceryItemPicture.layer.masksToBounds = false
        cell.groceryItemPicture.layer.shadowRadius = 2
        
        
        return cell
    }
    
}
