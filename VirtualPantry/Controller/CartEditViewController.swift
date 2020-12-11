//
//  CartEditViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 12/9/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import ProgressHUD
class CartEditViewController: UIViewController {

    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var descriptionText: UITextField!

    @IBOutlet weak var itemPic: UIImageView!
    
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var emergencyFlag: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var warningFlag: UITextField!
    
    @IBOutlet weak var okayFlag: UITextField!
    
    @IBOutlet weak var quantityFlag: UITextField!
    @IBOutlet weak var date: UITextField!
    
    private var datePicker: UIDatePicker?
    var indexPath: Int?
    var food: Food?
    var db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = food?.name
        priceField.text = "\(food?.price as! Int)"
        emergencyFlag.text = "\(food?.emergencyFlag as! Int)"
        warningFlag.text = "\(food?.warningFlag as! Int)"
        descriptionText.text = "\(food?.description as! String)"
        okayFlag.text = "\(food?.okayFlag as! Int)"
        quantityFlag.text = "\(food?.quantity as! Int)"
        date.text = "\(food?.expirationDate as! String)"
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        date.inputView = datePicker

    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        
        
    }
    
    @IBAction func calculateTotal(_ sender: Any) {
        let price = Double(priceField.text!) ?? 0
        let amount = Double(quantityFlag.text!) ?? 0
        let total = price * amount ?? 0
        
        totalLabel.text = String(format: "$%.2f" , total)
    }
    

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: Any) {
        db.collection("groceryItems").document(food!.docItemRef).updateData([
                                                                                "description": descriptionText.text!,
                                                                                "name": name.text!,
                                                                                "expiration": date.text!,
                                                                                "price" : Int(priceField.text!)!,
                                                                                "quantity": Int(quantityFlag.text!)!,
                                                                                            "emergencyFlag": Int(emergencyFlag.text!),
                                                                                            "warningFlag" : Int(warningFlag.text!),
                                                                                "okayFlag" : Int(okayFlag.text!)]
        )
        
        _ = navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("loadGroceryData"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        db.collection("groceryItems").document(food!.docItemRef).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
            
            else {
                ProgressHUD.showSuccess("Successfully deleted \(self.food?.name as! String)")
                print("Document successfully removed!")
                ShoppingCartViewController.foodArray.removeAll {$0 == self.food}
                print("count here is :\(ShoppingCartViewController.foodArray.count)")
                let docRef = self.db.collection("users").document(uid!)
                docRef.getDocument { [self] (document, error) in
                    if let document = document {
                        var arr = document.get("groceryItems") as! [String]
                        arr.removeAll { $0 == food?.docItemRef }
                        db.collection("users").document(uid!).updateData(["groceryItems" : arr])
                    }
                }
            }
        }
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("loadGroceryData"), object: nil)
        }
    }
}
