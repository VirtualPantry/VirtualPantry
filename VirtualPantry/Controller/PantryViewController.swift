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
import FirebaseStorage
import ProgressHUD
class PantryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: PantryMenuButton!
    @IBOutlet weak var searchBar: UISearchBar!
    let db = Firestore.firestore()
    
    static var filteredData: [Food] = []
    static var foodArray: [Food] = []
    //static var foodDoc : [String]!
    @IBOutlet var priceLabel: UILabel!

    
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
        
        PantryViewController.filteredData = PantryViewController.foodArray
        NotificationCenter.default.addObserver(self, selector: #selector(loadPantryData(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeItems(notification:)), name: NSNotification.Name(rawValue: "removePantryItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goAddItem(notification:)), name: NSNotification.Name(rawValue: "addPantryItem"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
    }
    
    @objc func loadPantryData(notification: NSNotification) {
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let docRef = db.collection("users").document(uid)
        PantryViewController.foodArray = []
        PantryViewController.filteredData = []
        docRef.getDocument(completion: { [self] (document, error) in
            if let document = document, document.exists{
                let pantryItemUIDs = document.get("pantryItems") as? [String] ?? []
                for pantryItemUID in pantryItemUIDs{
                    let docItemRef = db.collection("pantryItems").document(pantryItemUID)
                    docItemRef.getDocument { (document, error) in
                        let json = document?.data() as? [String : Any?]  ?? [:]
                        var food : Food = Food()
                        
                        if(json.isEmpty){
                            return
                        }
                        
                        food.name = json["name"] as! String
                        food.emergencyFlag = json["emergencyFlag"] as! Int
                        food.description = json["description"] as! String
                        food.okayFlag = json["okayFlag"] as! Int
                        food.price = json["price"] as! Int
                        food.quantity = json["quantity"] as! Int
                        food.warningFlag = json["warningFlag"] as! Int
                        food.picPath = json["picPath"] as! String
                        food.expirationDate = json["expiration"] as! String
                        food.docItemRef = docItemRef.documentID as! String
                        PantryViewController.foodArray.append(food)
                        PantryViewController.filteredData = PantryViewController.foodArray
                        collectionView.reloadData()
                    }
                    
                }

                print("collection view count : \(PantryViewController.foodArray.count)")
                print("filterData count : \(PantryViewController.filteredData.count)")
                collectionView.reloadData()
            }
        })
    }
    

    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PantryViewController.filteredData.count
    }
    
   
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PantryItemCell", for: indexPath) as! PantryItemCell
        let food = PantryViewController.filteredData[indexPath.row]
        let dispatch = DispatchGroup()
        cell.nameLabel.text = food.name
        cell.currentQuantity = food.quantity
        cell.okayFlag = food.okayFlag
        cell.emergencyFlag = food.emergencyFlag
        cell.warningFlag = food.warningFlag
        cell.quantityLabel.text = "Quantity: \(food.quantity)"
        cell.expirationDateLabel.text = "Expiration Date: \(food.expirationDate)"
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let picRef = storageRef.child(food.picPath)
        picRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            cell.pantryItemPicture.image = UIImage(data: data!)
          }
        }
        
        cell.pantryItemPicture.layer.cornerRadius = 15
        cell.pantryItemPicture.clipsToBounds = true
        cell.pantryItemPicture.layer.masksToBounds = true
        cell.pantryItemPicture.layer.shadowRadius = 15
        cell.setColor()
        
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        PantryViewController.filteredData = searchText.isEmpty ? PantryViewController.foodArray : PantryViewController.foodArray.filter { (item: Food) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }
    
    @objc func goAddItem(notification: NSNotification){
        self.performSegue(withIdentifier: "goAddItem", sender: self)
    }
    
    @objc func removeItems(notification: NSNotification){
        let user = Auth.auth().currentUser
        let uid = (user?.uid)!
        db.collection("users").document(uid).updateData([
            "pantryItems": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                ProgressHUD.showSuccess("All items successfully deleted!")
            }
        }
        PantryViewController.foodArray = []
        PantryViewController.filteredData = PantryViewController.foodArray
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goEditItem" {
            let cell = sender as! PantryItemCell
            if let indexPath = collectionView.indexPath(for: cell) {
                let EditViewController = segue.destination as! EditItemViewController
                let food = PantryViewController.foodArray[indexPath.row]
                EditViewController.food = food
                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let picRef = storageRef.child(food.picPath)
                picRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                  } else {
                    // Data for "images/island.jpg" is returned
                    EditViewController.itemPic.image = UIImage(data: data!)
                  }
                }
            }
        }
    }
    
    
}
