import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()!.options.clientID

        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInSuccessFul", sender: self)
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(signedIn), name: Notification.Name("UserLoggedIn"), object: nil)
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
                    self.performSegue(withIdentifier: "signInSuccessFul", sender: self)
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
    
    @objc func signedIn(note : Notification){
        self.performSegue(withIdentifier: "signInSuccessFul", sender: self)
    }
}
