//
//  Edit-Add-ViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 11/24/20.
//

import UIKit
import ProgressHUD
import FirebaseFirestore
import FirebaseAuth
class Edit_Add_ViewController: UIViewController {

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet weak var itemPicture: UIImageView!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var emergencyFlag: UITextField!
    @IBOutlet weak var currentAmount: UITextField!
    @IBOutlet weak var okFlag: UITextField!
    @IBOutlet weak var warningFlag: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currentQuantity: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func validateFields() -> String? {
        // is everything filled in?
        if itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            itemDescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            itemPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    func sendDataToFirebase(_ sender: Any) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = (user?.uid)!
        var addItems = [String]()
        let error = validateFields()
        if error == nil {
            addItems.append(itemNameTextField.text!)
            db.collection("items").document(itemNameTextField.text!).setData([
                                                                                "description": itemDescriptionTextField.text!,
                                                                                "name": itemNameTextField.text!,
                                                                    
                                                                                "price" : itemPrice.text!,
                                                                                "quantity": currentQuantity.text!])
            
            db.collection("users").document(uid).updateData(["groceryItems" : FieldValue.arrayUnion(addItems)])
        } else {
            ProgressHUD.showError(error)
        }
    }
    @IBAction func backTapped(_ sender: Any) {
    }
    @IBAction func addTapped(_ sender: Any) {
        sendDataToFirebase(self)
    }
    @IBAction func deleteTapped(_ sender: Any) {
    }
}
