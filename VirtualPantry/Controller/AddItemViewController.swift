//
//  AddItemViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 12/3/20.
//

import UIKit
import ProgressHUD
import FirebaseFirestore
import FirebaseAuth
import AlamofireImage
class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemPicture: UIImageView!
    
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var emergencyFlag: UITextField!
    @IBOutlet weak var warningFlag: UITextField!
     var name: String?
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var okFlag: UITextField!
    
    @IBOutlet weak var quantity: UITextField!
    
    @IBOutlet weak var expirationDateTF: UITextField!
    private var datePicker: UIDatePicker?
   
    override func viewDidLoad() {
           super.viewDidLoad()
           
           datePicker = UIDatePicker()
           datePicker?.datePickerMode = .date
           datePicker?.addTarget(self, action: #selector(AddItemViewController.dateChanged(datePicker:)), for: .valueChanged)
           
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
           view.addGestureRecognizer(tapGesture)
           
           expirationDateTF.inputView = datePicker
           
           

           // Do any additional setup after loading the view.
       }
       
       @objc func viewTapped(gesture: UITapGestureRecognizer) {
           view.endEditing(true)
       }
       
       
       @objc func dateChanged(datePicker: UIDatePicker) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MM/dd/yyyy"
           expirationDateTF.text = dateFormatter.string(from: datePicker.date)
           view.endEditing(true)
           
           
       }
    
    
    func validateFields() -> String? {
            // is everything filled in?
            if itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                itemDescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                itemPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emergencyFlag.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                okFlag.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                warningFlag.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                quantity.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                expirationDateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill in all fields"
            }
        
//            let price = Double(self.itemPrice.text!)!
//            let quant = Double(self.quantity.text!)!
//            let total = price * quant
//            self.totalLabel.text = "$\(total)"
            return nil
        }
    
        func sendDataToFirebase(_ sender: Any) {
            let db = Firestore.firestore()
            let user = Auth.auth().currentUser
            let uid = (user?.uid)!
            var addItems = [String]()
            let error = validateFields()
            if error == nil {
                var ref: DocumentReference? = nil
                ref = db.collection("pantryItems").addDocument(data:[
                                                                "description": itemDescriptionTextField.text!,
                                                                "name": itemNameTextField.text!,
                                                                "expiration": expirationDateTF.text!,
                                                    
                                                                "price" : Int(itemPrice.text!)!,
                                                                "quantity": Int(quantity.text!)!,
                                                                            "emergencyFlag": emergencyFlag.text!,
                                                                            "warningFlag" : warningFlag.text!,
                                                                            "okayFlag" : okFlag.text!])
                name = ref!.documentID
                PantryViewController.foodDoc.append(name!)
               // let quant = Int(quantity.text!)!
                //PantryViewController.quantities.append(quant)
                addItems.append(name!)
                db.collection("users").document(uid).updateData(["pantryItems" : FieldValue.arrayUnion(addItems)])
                print(addItems)
            } else {
                ProgressHUD.showError(error)
            }
        }
    
    @IBAction func backTapped(_ sender: Any) {
                _ = navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
            }
            @IBAction func addTapped(_ sender: Any) {
                if self.validateFields() == nil {
                    sendDataToFirebase(self)
                    _ = navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
                } else {
                    ProgressHUD.showError(self.validateFields())
                }

                
                
            }
        
        @IBAction func cameraTapped(_ sender: Any) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
              picker.sourceType = .camera
           } else {
                picker.sourceType = .photoLibrary
            }
            present(picker, animated: true, completion: nil)
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.editedImage] as! UIImage
            let size = CGSize(width: 250, height: 250)
            let scaledImage = image.af.imageScaled(to: size)
            
            itemPicture.image = scaledImage
            let db = Firestore.firestore()
            let user = Auth.auth().currentUser
            let uid = (user?.uid)!
            db.collection("items").document(itemNameTextField.text! + uid).updateData([
                                                                                        "picture": itemPicture.image!])
        }

}
