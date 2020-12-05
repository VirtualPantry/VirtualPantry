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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayCurrentItem(self)
        
    }
    
    
    func displayCurrentItem(_ sender: Any) {
        let user = Auth.auth().currentUser
        let uid = (user?.uid)!
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        var currentItem = ""
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let pantryItems = document.data()!["pantryItems"] as! [Any]
                currentItem = pantryItems[0] as! String
            }
        }
        
        let item = db.collection("pantryItems").document(currentItem)
        
        item.getDocument { (document, error) in
            if let document = document, document.exists {
                let name = document.get("name")
                let description = document.get("description")
                let price = document.get("price")
                let eFlag = document.get("emergencyFlag")
                let wFlag = document.get("warningFlag")
                let oFlag = document.get("okayFlag")
                let quantity = document.get("quantity")
                let picture = document.get("picture") ?? nil
                
                print(name!)
                print(description!)
                print(price!)
                print(eFlag!)
                print(wFlag!)
                print(oFlag!)
                print(quantity!)
            }
        }
    }
    
    func itemEdited(_ sender: Any) {
        
    }
    
    @IBAction func finishEdit(_ sender: Any) {
        itemEdited(self)
    }

}
