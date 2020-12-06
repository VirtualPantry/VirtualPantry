//
//  PantryViewController.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/27/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase


class PantryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: PantryMenuButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    static var foodDoc : [String] = []
    static var quantities : [Int] = []
    var filteredData: [Food]!
    static var foodArray: [Food] = []
    
    
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
        
        filteredData = PantryViewController.foodArray
        NotificationCenter.default.addObserver(self, selector: #selector(loadData(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
    }
    
    @objc func loadData(notification: NSNotification) {
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let docRef = db.collection("users").document(uid)
        PantryViewController.foodArray = []
        docRef.getDocument(completion: { [self] (document, error) in
            if let document = document, document.exists{
                let pantryItemUIDs = document.get("pantryItems") as? [String] ?? []
                for pantryItemUID in pantryItemUIDs{
                    let docItemRef = db.collection("pantryItems").document(pantryItemUID)
                    docItemRef.getDocument { (document, error) in
                        let json = document?.data() as! [String : Any?]
                        var food : Food = Food()
                        food.name = json["name"] as! String
                        food.emergencyFlag = json["emergencyFlag"] as? Int ?? 0
                        food.description = json["description"] as! String
                        food.okayFlag = json["okayFlag"] as? Int ?? 3
                        food.price = json["price"] as! Int
                        food.quantity = json["quantity"] as! Int
                        food.warningFlag = json["warningFlag"] as? Int ?? 1
                        food.expirationDate = json["expireDate"] as? String ?? "Expiration Date: "
                       // if !checkIfFood(fod: food) {
                            PantryViewController.foodArray.append(food)
                        //}
                        self.filteredData = PantryViewController.foodArray
                        collectionView.reloadData()
                    }
                }
            }
        })
    }
    func checkIfFood(fod: Food) -> Bool {
        if PantryViewController.foodArray.contains(where: { (fod) -> Bool in
            return true
        }) {
            
        }
        return false
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PantryViewController.foodArray.count
    }
    
   
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PantryItemCell", for: indexPath) as! PantryItemCell
        
//        // TODO : Move this logic into the grocery cell or make another image view
//        let itemID = filteredData[indexPath.row]
//        let item = db.collection("pantryItems").document(itemID)
//
//        item.getDocument { (document, error) in
//            if let document = document {
//                let property = document.get("name")
//                let quantity = document.get("quantity") as! Int
//                cell.quantityLabel.text = "Quantity: \(quantity)"
//                cell.currentQuantity = quantity as Int
//
//                cell.nameLabel.text = (property as! String)
//            } else {
//                print("Document does not exist in cache")
//            }
//        }
        
        let food = filteredData[indexPath.row]
       
        cell.nameLabel.text = food.name
        cell.currentQuantity = food.quantity
        cell.okayFlag = food.okayFlag
        cell.emergencyFlag = food.emergencyFlag
        cell.warningFlag = food.warningFlag
        cell.quantityLabel.text = "Quantity \(String(food.quantity))"
        cell.expirationDateLabel.text = "Expiration Date: \(food.expirationDate)"
        
    
        cell.pantryItemPicture.layer.cornerRadius = 15
        cell.pantryItemPicture.clipsToBounds = true
        cell.pantryItemPicture.layer.masksToBounds = true
        cell.pantryItemPicture.layer.shadowRadius = 15
        
    
        cell.setColor()
        
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredData = searchText.isEmpty ? PantryViewController.foodDoc : PantryViewController.foodDoc.filter { (item: String) -> Bool in
//                    // If dataItem matches the searchText, return true to include it
//                    return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
        
        collectionView.reloadData()
    }
    
    
    
    
    func performSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "goAddItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
}
