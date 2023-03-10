//
//  LoginVC.swift
//  Author's name : Amrik Singh
//  StudentID : 301296257
//
//  Slot Machine Part 3
//
//  Created by Amrik on 18/02/23.
// Version: 1.3

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginVC: UIViewController {
    //MARK: Variables and connections
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK: Login user
    @IBAction func btnLoginAct(_ sender: Any) {
        //MARK: validations for user
        if !(Utility.shared.isValidEmail(txtEmail.text ?? "")) {
            Utility.shared.displayPopup(title: "", msg: "Please enter valid email.", VC: self)
        } else if !(Utility.shared.isValidPassword(txtPassword.text ?? "")) {
            Utility.shared.displayPopup(title: "", msg: "Please enter 6 character password.", VC: self)
        }  else  {
            Utility.shared.showActivityIndicatory(vc: self)
            Auth.auth().signIn(withEmail: txtEmail.text ?? "", password: txtPassword.text ?? "") { (authResult, error) in // MARK: SignIn user
                Utility.shared.hideActivityIndicator()
              if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .emailAlreadyInUse:
                    Utility.shared.displayPopup(title: "", msg: "The email address is already in use by another account.", VC: self)
                    break
                case .invalidEmail:
                    Utility.shared.displayPopup(title: "", msg: "The email address is badly formatted.", VC: self)
                    break
                case .weakPassword:
                    Utility.shared.displayPopup(title: "", msg: "The password must be 6 characters long or more.", VC: self)
                    break
                default:
                    Utility.shared.displayPopup(title: "Error", msg: "\(error.localizedDescription)", VC: self)
                }
              } else {
                  
                  guard let appDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
                  appDelegate.manageLoginSession(isfromSignup: false)
              }
        }
     }
    }
    
    @IBAction func btnSignupAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
