//
//  SignUpViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 11/14/20.
//

import UIKit
import FirebaseAuth
import Firebase
class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
    }
    
    // check the fields and make sure data is good
    func validateFields() -> String? {
        // is everything filled in?
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        // is password secure?
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character, and a number!"
        }
        
        // nil means everything is fine
        return nil
    }
    // password checker
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-ZA-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    @IBAction func signUpButton(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            // cleaned fields
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                // Check for errors
                if error != nil {
                    // Error is not nil and there is a problem
                    self.showError("Error creating user")
                } else {
                    // Store name in database
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData(["name": name,"uid":result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("User data could not be saved")
                        }
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
            // Transition to the Shopping Cart
            //self.transition2ShoppingCart()
            
        }
     
        
 
    }
    func transition2ShoppingCart() {
       let shoppingCart =  storyboard?.instantiateViewController(identifier: constant.StoryBoard.cartVC) as? ShoppingCartViewController
        
        view.window?.rootViewController = shoppingCart
        view.window?.makeKeyAndVisible()
    }
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
