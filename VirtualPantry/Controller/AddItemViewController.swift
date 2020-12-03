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
import AlamofireImage

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemPicture: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var emergencyFlag: UITextField!
    @IBOutlet weak var currentAmount: UITextField!
    @IBOutlet weak var okFlag: UITextField!
    @IBOutlet weak var warningFlag: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var quantity: UITextField!
    
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
            itemPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emergencyFlag.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            okFlag.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            warningFlag.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            quantity.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
            let price = Double(self.itemPrice.text!)!
            let quant = Double(self.quantity.text!)!
            let total = price * quant
            self.totalLabel.text = "$\(total)"
            var ref: DocumentReference? = nil
            ref = db.collection("pantryItems").addDocument(data:[
                                                            "description": itemDescriptionTextField.text!,
                                                            "name": itemNameTextField.text!,
                                                
                                                            "price" : itemPrice.text!,
                                                            "quantity": quantity.text!,
                                                                        "emergencyFlag": emergencyFlag.text!,
                                                                        "warningFlag" : warningFlag.text!,
                                                                        "okayFlag" : okFlag.text!])
            let name = ref!.documentID
            addItems.append(name)
            db.collection("users").document(uid).updateData(["pantryItems" : FieldValue.arrayUnion(addItems)])


        } else {
            ProgressHUD.showError(error)
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addTapped(_ sender: Any) {
        sendDataToFirebase(self)
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
