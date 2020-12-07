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
    
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayCurrentItem()
        
    }
    
    
    func displayCurrentItem() {
        let currentItem = PantryViewController.foodArray[indexPath!]
        
        
        
        
        
        
        
       
        }
    
    func itemEdited(_ sender: Any) {
        
    }
    
    @IBAction func finishEdit(_ sender: Any) {
        itemEdited(self)
    }
    
    
}
    
    


