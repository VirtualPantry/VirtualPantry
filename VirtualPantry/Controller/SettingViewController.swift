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
}
