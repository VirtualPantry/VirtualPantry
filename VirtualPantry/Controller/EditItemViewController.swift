//
//  EditItemViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 12/3/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import ProgressHUD
class EditItemViewController: UIViewController {

    var indexPath: Int?
    var food : Food?
    var db = Firestore.firestore()
    
    
    @IBOutlet var descriptionText: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet var emergencyFlag: UITextField!
    @IBOutlet var warningFlag: UITextField!
    @IBOutlet var okayFlag: UITextField!
    @IBOutlet var quantityFlag: UITextField!
    @IBOutlet var date: UITextField!
    @IBOutlet var totalLabel: UILabel!
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = food?.name
        price.text = "\(food?.price as! Int)"
        emergencyFlag.text = "\(food?.emergencyFlag as! Int)"
        warningFlag.text = "\(food?.warningFlag as! Int)"
        descriptionText.text = "\(food?.description as! String)"
        okayFlag.text = "\(food?.okayFlag as! Int)"
        quantityFlag.text = "\(food?.quantity as! Int)"
        date.text = "\(food?.expirationDate as! String)"
        
        let prices = Double(price.text!) ?? 0
        let amount = Double(quantityFlag.text!) ?? 0
        let total = prices * amount ?? 0
        
        totalLabel.text = String(format: "$%.2f" , total)
        
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
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calculateTotal(_ sender: Any) {
        let prices = Double(price.text!) ?? 0
        let amount = Double(quantityFlag.text!) ?? 0
        let total = prices * amount ?? 0
        
        totalLabel.text = String(format: "$%.2f" , total)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        db.collection("pantryItems").document(food!.docItemRef).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                ProgressHUD.show("Successfully deleted \(self.food?.name)")
                print("Document successfully removed!")
            }
        }
    }
    @IBAction func updateTapped(_ sender: Any) {
        db.collection("pantryItems").document(food!.docItemRef).updateData([
                                                                                "description": descriptionText.text!,
                                                                                "name": name.text!,
                                                                                "expiration": date.text!,
                                                                    
                                                                                "price" : Int(price.text!)!,
                                                                                "quantity": Int(quantityFlag.text!)!,
                                                                                            "emergencyFlag": emergencyFlag.text!,
                                                                                            "warningFlag" : warningFlag.text!,
                                                                            "okayFlag" : okayFlag.text!])
        
        _ = navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
        dismiss(animated: true, completion: nil)
                                                        
    }
}
    
    


