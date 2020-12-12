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
import AlamofireImage
class PantryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: PantryMenuButton!
    @IBOutlet weak var searchBar: UISearchBar!
    let db = Firestore.firestore()
    
    static var filteredData: [Food] = []
    static var foodArray: [Food] = []
    static var warningUIDs: [String] = []


    
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
        PantryViewController.warningUIDs = []
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
                        food.price = Int(json["price"] as! Double)
                        food.quantity = json["quantity"] as! Int
                        food.warningFlag = json["warningFlag"] as! Int
                        food.picPath = json["picPath"] as! String
                        food.expirationDate = json["expiration"] as! String
                        food.docItemRef = docItemRef.documentID as! String
                        PantryViewController.foodArray.append(food)
                        PantryViewController.filteredData = PantryViewController.foodArray
                        
                        
                        let currentDate = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        dateFormatter.timeZone = TimeZone.current
                        dateFormatter.locale = Locale.current
                        let foodDate = dateFormatter.date(from: food.expirationDate) as! Date
                        
                        
                        if food.quantity < food.warningFlag || currentDate > foodDate{
                            PantryViewController.foodArray.removeAll{$0 == food}
                            PantryViewController.filteredData.removeAll{$0 == food}
                            PantryViewController.warningUIDs.append(food.docItemRef as! String)
                            db.collection("users").document(uid).updateData(["groceryItems" : FieldValue.arrayUnion(PantryViewController.warningUIDs)])
                            
                            
                            
                            // add doc to groceryItems
                            db.collection("groceryItems").document(food.docItemRef as! String).setData([
                                                                                                        "description": food.description,
                                                                                                        "name": food.name,
                                                                                                        "expiration": food.expirationDate,
                                                                                                        "price" : food.price,
                                                                                                        "quantity": food.quantity,
                                                                                                        "emergencyFlag": food.emergencyFlag,
                                                                                                        "warningFlag" : food.warningFlag,
                                                                                                        "okayFlag" : food.okayFlag,
                                                                                                        "picPath" : food.picPath])
                             
                            
                            db.collection("users").document(uid).updateData(["pantryItems" : FieldValue.arrayRemove(PantryViewController.warningUIDs)])
                            self.showToast(message: "\(food.name) moved", font: .systemFont(ofSize: 12.0))
                            NotificationCenter.default.post(name: Notification.Name("loadGroceryData"), object: nil)
                        }
                        
                        collectionView.reloadData()
                    }
                }
                
//                if PantryViewController.warningUIDs.count > 0 {
//                    NotificationCenter.default.post(name: Notification.Name("sendWarningUIDs"), object: nil)
//                }
                collectionView.reloadData()
            }
        })
        
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PantryViewController.filteredData.count
    }
    
    @IBAction func sendAllItem(_ sender: Any) {
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                let pantryItemUIDs = document.get("pantryItems") as? [String] ?? []
                self.db.collection("users").document(uid).updateData(["groceryItems" : FieldValue.arrayUnion(pantryItemUIDs)])
                
                for itemID in pantryItemUIDs {
                    let ref = self.db.collection("groceryItems").document(itemID)
                    ref.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let name = document.get("name")
                            let price = document.get("price")
                            let description = document.get("description")
                            let emergencyFlag = document.get("emergencyFlag")
                            let okFlag = document.get("okayFlag")
                            let warningFlag = document.get("warningFlag")
                            let quantity = document.get("quantity")
                            let expiration = document.get("expiration")
                            let picPath = document.get("picPath")
                            self.db.collection("pantryItems").document(itemID).setData([ "name": name, "price": price, "description" : description, "emergencyFlag" : emergencyFlag, "okayFlag": okFlag, "warningFlag": warningFlag, "quantity": quantity, "expiration" : expiration, "picPath" : picPath])
                            
                        }
                    }

                }
                
                NotificationCenter.default.post(name: Notification.Name("removePantryItem"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("loadGroceryData"), object: nil)
            }
        }
    }
    
    
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PantryItemCell", for: indexPath) as! PantryItemCell
        let food = PantryViewController.filteredData[indexPath.row]
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
            DispatchQueue.main.async {
                
                cell.pantryItemPicture.image = UIImage(data: data!)
            }
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
        
        
        if PantryViewController.filteredData.count == 0 {
            self.showToast(message: "No Results", font: .systemFont(ofSize: 12.0))
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
                    DispatchQueue.main.async {
                        EditViewController.itemPic.image = UIImage(data: data!)
                    }
                  }
                }
            }
        }
    }
    
    
}


extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 15))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
