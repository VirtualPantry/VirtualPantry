//
//  LoginViewController.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/8/20.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButton(_ sender: Any) {
        // validate email and pass
        let error = validateFields()
        
        //Sign in
        if error == nil {
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    let shoppingCart =  self.storyboard?.instantiateViewController(identifier: constant.StoryBoard.cartVC) as? ShoppingCartViewController
                     
                    self.view.window?.rootViewController = shoppingCart
                    self.view.window?.makeKeyAndVisible()
                }
            }
        } else {
            self.errorLabel.text = "Invalid username or password"
            self.errorLabel.alpha = 1
        }
        
    }
    func validateFields() -> String? {
        // is everything filled in?
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        // nil means everything is fine
        return nil
    } 
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
          }
          guard let authentication = user.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if error != nil {
                print("\(error)")
            } else {
                self.view.window?.rootViewController?.performSegue(withIdentifier: "ShoppingCart", sender: self)
            }
        }
    }
}
