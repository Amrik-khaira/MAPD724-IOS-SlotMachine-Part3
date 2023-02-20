//
//  SettingVC.swift
//  Author's name : Amrik Singh
//  StudentID : 301296257
//
//  Slot Machine Part 3
//
//  Created by Amrik on 19/02/23.
// Version: 1.3

import UIKit
import FirebaseAuth
import MessageUI
class SettingVC: UIViewController, UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    //MARK: logout app
    @IBAction func btnLogoutAct(_ sender: Any) {
        do {
           try Auth.auth().signOut()
            guard let appDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else { return }
            appDelegate.manageLoginSession(isfromSignup: false)
         } catch {
           print("Sign out error")
         }
    }
    
    //MARK: open pdf app document
    @IBAction func btnHelpAct(_ sender: Any) {
        let path =  Bundle.main.path(forResource: "Slot Machine Documnetations", ofType: ".pdf")!
        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
        dc.delegate = self
        dc.presentPreview(animated: true)
    }
    
    @IBAction func btnSupportAct(_ sender: Any) {
        sendEmail()
    }
    
    //MARK: open mail compose
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["Amrik.khaira91@gmail.com"])
            mail.setSubject("Slot Machine game feedback")
            mail.setMessageBody("Version: \(Bundle.main.releaseVersionNumber ?? "1.3") \n Build: \(Bundle.main.buildVersionNumber ?? "1")", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            Utility.shared.displayPopup(title: "Slot Machine", msg: "The iOS Simulator is not support Mail Compose. Please try on a real device.", VC: self)
        }
    }
    //MARK: open mail compose deletgate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //MARK: UIDocumentInteractionController delegates
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self//or use return self.navigationController for fetching app navigation bar colour
    }
}
