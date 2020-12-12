//
//  ShoppingCartViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 11/14/20.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseStorage
import ProgressHUD

class ShoppingCartViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuButton: GroceryListMenuButton!
    @IBOutlet weak var totalLabel: UILabel!
    var total : Int = 0
    
    let db = Firestore.firestore()
    static var filteredData: [Food] = []
    static var foodArray: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring the collection view
        self.totalLabel.text = ""
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
        
        ShoppingCartViewController.filteredData = ShoppingCartViewController.foodArray
        NotificationCenter.default.addObserver(self, selector: #selector(loadGroceryData(notification:)), name: NSNotification.Name(rawValue: "loadGroceryData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeGroceryItem(notification:)), name: NSNotification.Name(rawValue: "removeGroceryItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addGroceryItem(notification:)), name: NSNotification.Name(rawValue: "addGroceryItem"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("loadGroceryData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSendingGroceryItems(notification:)), name: NSNotification.Name(rawValue: "removeSendingGroceryItems"), object: nil)
    }
    
    @objc func loadGroceryData(notification: Notification){
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let docRef = db.collection("users").document(uid)
        ShoppingCartViewController.foodArray = []
        ShoppingCartViewController.filteredData = []
        docRef.getDocument { [self] (document, error) in
            if let document = document, document.exists{
                let groceryItemUIDs = document.get("groceryItems") as? [String] ?? []
                print(groceryItemUIDs.count)
                for groceryItemUID in groceryItemUIDs{
                    let docItemRef = db.collection("groceryItems").document(groceryItemUID)
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
                        
                        ShoppingCartViewController.foodArray.append(food)
                        ShoppingCartViewController.filteredData = ShoppingCartViewController.foodArray
                        collectionView.reloadData()
                    }
                }
                
                collectionView.reloadData()
            }
        }
    }
    
    @objc func addGroceryItem(notification: Notification){
        self.performSegue(withIdentifier: "goAddGroceryItem", sender: self)
    }
    
    @objc func removeGroceryItem(notification: Notification){
        let user = Auth.auth().currentUser
        let uid = (user?.uid)!
        db.collection("users").document(uid).updateData([
            "groceryItems": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                ProgressHUD.showSuccess("All items successfully deleted!")
            }
        }
        ShoppingCartViewController.foodArray = []
        ShoppingCartViewController.filteredData = ShoppingCartViewController.foodArray
        collectionView.reloadData()
    }
    
    @objc func removeSendingGroceryItems(notification: Notification){
        let user = Auth.auth().currentUser
        let uid = (user?.uid)!
        db.collection("users").document(uid).updateData([
            "groceryItems": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                ProgressHUD.showSuccess("All items are sent to Pantry!")
            }
        }
        ShoppingCartViewController.foodArray = []
        ShoppingCartViewController.filteredData = ShoppingCartViewController.foodArray
        collectionView.reloadData()
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShoppingCartViewController.filteredData.count
    }
    
    // Return the custom cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
        
        
        if(indexPath.row == 0){
            total = 0;
        }
        
        // TODO : Move this logic into the grocery cell or make another image view
        
        let food = ShoppingCartViewController.foodArray[indexPath.row]
        
        cell.nameLabel.text = food.name
        cell.currentQuantity = food.quantity
        cell.okayFlag = food.okayFlag
        cell.emergencyFlag = food.emergencyFlag
        cell.warningFlag = food.warningFlag
        cell.quantityLabel.text = "Quantity: \(food.quantity)"
        total = total + food.price * food.quantity
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current

        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: food.price))!
        let totalString = currencyFormatter.string(from: NSNumber(value: total))!
        cell.priceLabel.text = "Price per item: \(priceString)"
        print(priceString)
        
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let picRef = storageRef.child(food.picPath)
        picRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            DispatchQueue.main.async {
                cell.groceryItemPicture.image = UIImage(data: data!)
            }
          }
        }
        
        self.totalLabel.text = totalString
        cell.groceryItemPicture.layer.cornerRadius = 15
        cell.groceryItemPicture.clipsToBounds = true
        cell.groceryItemPicture.layer.masksToBounds = true
        cell.groceryItemPicture.layer.shadowRadius = 15
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ShoppingCartViewController.filteredData = searchText.isEmpty ? ShoppingCartViewController.foodArray : ShoppingCartViewController.foodArray.filter { (item: Food) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        collectionView.reloadData()
    }
    
    
    
    @IBAction func sendAllItem(_ sender: Any) {
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                let groceryItemUIDs = document.get("groceryItems") as? [String] ?? []
                self.db.collection("users").document(uid).updateData(["pantryItems" : FieldValue.arrayUnion(groceryItemUIDs)])
                
                for itemID in groceryItemUIDs {
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
                NotificationCenter.default.post(name: Notification.Name("removeSendingGroceryItems"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goEditGroceryItem" {
            let cell = sender as! GroceryItemCell
            if let indexPath = collectionView.indexPath(for: cell) {
                let EditViewController = segue.destination as! CartEditViewController
                let food = ShoppingCartViewController.foodArray[indexPath.row]
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
