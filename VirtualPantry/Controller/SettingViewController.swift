//
//  SettingViewController.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/17/20.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingViewController: UIViewController {

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

    @IBAction func onSignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        }
        
        catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        self.performSegue(withIdentifier: "signedOut", sender: self)
          
    }
    
    
    @IBAction func onTapToChangePassword(_ sender: Any) {
        
        showPasswordResetAlert()
        
        // get current firebase user
        var user = Auth.auth().currentUser
        
        if let user = user {
            let email = user.email!
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                print("Error with resetting your password via email")
                }
            }
    }
    
    func showPasswordResetAlert() {
        let alert = UIAlertController(title: "Password Reset Request", message: "The email to reset your password has been sent.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in print("dismissed")
            
        }))
        self.present(alert, animated: true)
    }
    
    
}
    
