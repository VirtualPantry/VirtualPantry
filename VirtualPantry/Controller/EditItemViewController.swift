//
//  EditItemViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 12/3/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class EditItemViewController: UIViewController {

    var indexPath: Int?
    var food : Food? 
    
    @IBOutlet var descriptionText: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet var emergencyFlag: UITextField!
    @IBOutlet var warningFlag: UITextField!
    @IBOutlet var okayFlag: UITextField!
    @IBOutlet var quantityFlag: UITextField!
    @IBOutlet var date: UITextField!
    @IBOutlet var totalLabel: UILabel!
    
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
    
}
    
    


