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
import Firebase
import FirebaseStorage

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemPicture: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var emergencyFlag: UITextField!
    @IBOutlet weak var warningFlag: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var okFlag: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var expirationDateTF: UITextField!
    private var datePicker: UIDatePicker?
    var name: String?
    var docRefItem: String = ""
    var image : UIImage?
    var imageURL : URL?
    var picPath : String?

    override func viewDidLoad() {
           super.viewDidLoad()
           
           datePicker = UIDatePicker()
           datePicker?.datePickerMode = .date
           datePicker?.addTarget(self, action: #selector(AddItemViewController.dateChanged(datePicker:)), for: .valueChanged)
           let user = Auth.auth().currentUser
           let uid = (user?.uid)!
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
           view.addGestureRecognizer(tapGesture)
           
           expirationDateTF.inputView = datePicker
            
           

           // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(sendPic(notification:)), name: NSNotification.Name(rawValue: "sendAddedItemPic"), object: nil)
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
                                                                "price" : Double(itemPrice.text!)!,
                                                                "quantity": Int(quantity.text!)!,
                                                                            "emergencyFlag": Int(emergencyFlag.text!)!,
                                                                            "warningFlag" : Int(warningFlag.text!)!,
                                                                            "okayFlag" : Int(okFlag.text!)!])
                name = ref!.documentID
                //PantryViewController.foodDoc.append(name!)
               // let quant = Int(quantity.text!)!
                //PantryViewController.quantities.append(quant)
                
                picPath = "\(uid as! String)/\(name as! String)"
                print("picPath")
                print(picPath)
                NotificationCenter.default.post(name: Notification.Name("sendAddedItemPic"), object: nil)
                
                
                db.collection("pantryItems").document(ref!.documentID).updateData(["picPath" : picPath])
//                db.collection("users").document(uid).updateData(["pantryItems" : FieldValue.arrayUnion(addItems)]){
//                    _ in
//                    _ = navigationController?.popViewController(animated: true)
//                    NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
//                    dismiss(animated: true, completion: nil)
//                }
                
                addItems.append(name!)
                db.collection("users").document(uid).updateData(["pantryItems" : FieldValue.arrayUnion(addItems)]){ error in
                    _ = self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                
                
                print(addItems)
            } else {
                ProgressHUD.showError(error)
            }
        }
    
     @IBAction func backTapped(_ sender: Any) {
                _ = navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
        dismiss(animated: true, completion: nil)
            }
            @IBAction func addTapped(_ sender: Any) {
                if self.validateFields() == nil {
                    sendDataToFirebase(self)
                } else {
                    ProgressHUD.showError(self.validateFields())
                }
        }
        
        @IBAction func cameraTapped(_ sender: Any) {
            let picker = UIImagePickerController()
            
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
            print("hello")
            image = info[.originalImage] as! UIImage
            let size = CGSize(width: 250, height: 250)
            let scaledImage = image?.af.imageScaled(to: size)
            itemPicture.image = scaledImage
            dismiss(animated: true, completion: nil)
           
            
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                    let imgName = UUID().uuidString
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    let data = image!.jpegData(compressionQuality: 0.3)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    imageURL = URL.init(fileURLWithPath: localPath)
            }
            
            else{
                let imgName = UUID().uuidString
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                let data = image!.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                imageURL = URL.init(fileURLWithPath: localPath)
            }
        }
    
    
    @objc func sendPic(notification : Notification) {
        // Gets user
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = (user?.uid)!
        
        // Local URL
        let localFile = imageURL as! URL
        
        // create reference in firestore
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child(picPath as! String)
        
        // upload the image to firestore
        let uploadTask = imageRef.putFile(from: localFile, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
    }
    
    
    /*
     
     var name: String?
     var docRefItem: String = ""
     var image : UIImage?
     var imageURL : URL?
     */
    
    
    
    @IBAction func calculateTotal(_ sender: Any) {
        let price = Double(itemPrice.text!) ?? 0
        let amount = Double(quantity.text!) ?? 0
        let total = price * amount ?? 0
        
        totalLabel.text = String(format: "$%.2f" , total)
    }
}
