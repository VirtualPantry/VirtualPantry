//
//  ForgotPasswordViewController.swift
//  VirtualPantry
//
//  Created by Shreyas Pant on 11/16/20.
//

import UIKit
import ProgressHUD
import Firebase
class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func resetTapped(_ sender: Any) {
        guard let email = emailTextField.text, email != "" else {
            ProgressHUD.showError("Please enter an email address to reset your password")
            return
        }
        resetPassword(email: email) {
            self.view.endEditing(true)
            ProgressHUD.showSuccess("We have sent you an email with instructions to reset your password.")
            self.dismiss(animated: true, completion: nil)
        } onError: { (error) in
            ProgressHUD.showError(error)
        }


    }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage:String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
    

}
