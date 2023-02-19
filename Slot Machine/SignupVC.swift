//
//  SignupVC.swift
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

class SignupVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var ref = DatabaseReference()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnLoginAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignupAct(_ sender: Any) {
        if (txtName.text ?? "" == "") {
            Utility.shared.displayPopup(title: "", msg: "Please enter name.", VC: self)
        } else if !(Utility.shared.isValidEmail(txtEmail.text ?? "")) {
            Utility.shared.displayPopup(title: "", msg: "Please enter valid email.", VC: self)
        } else if !(Utility.shared.isValidPassword(txtPassword.text ?? "")) {
            Utility.shared.displayPopup(title: "", msg: "Please enter 6 character password.", VC: self)
        }  else  {
        Auth.auth().createUser(withEmail: txtEmail.text ?? "", password: txtPassword.text ?? "") { authResult, error in
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
            print("User signs up successfully")
              self.ref = Database.database().reference()
              let newUserInfo = Auth.auth().currentUser
              self.ref.child("users/\(newUserInfo?.uid ?? "")").setValue(["username": self.txtName.text ?? "","userId": newUserInfo?.uid ?? "", "email": self.txtEmail.text ?? "", "wallet": 500, "wins": 0]){
                  (error:Error?, ref:DatabaseReference) in
                  if error == nil {
                      guard let appDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
                      appDelegate.manageLoginSession(isfromSignup: true)
                  }
              }
             
          }
        }
        }
    }
    
}
