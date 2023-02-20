//  Utility.swift
//  Author's name : Amrik Singh
//  StudentID : 301296257
//
//  Slot Machine Part 2
//
//  Created by Amrik on 04/02/23.
//
// Version: 2.0


import Foundation
import AVFoundation
import UIKit
import FirebaseAuth

class Utility {
    static let shared = Utility()
    var player : AVAudioPlayer?
    var activityView: UIActivityIndicatorView?
    
    //MARK: play sound accoring to the events
    func play(sound name: String,ext:String? = "mp3"){
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else{
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
    
    
    //MARK: Email RegEx for validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
      }
      
    //MARK: Password validation
      func isValidPassword(_ password: String) -> Bool {
        let minPasswordLength = 6
        return password.count >= minPasswordLength
      }
    
    //MARK: Alert function for showing messages
    func displayPopup(title: String = "Slot Machine", msg: String,VC:UIViewController) { // show alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { (_) in }))
        VC.present(alert, animated: true, completion: nil)
    }
    
    
    func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
    
    //MARK: Show loader on controller
    func showActivityIndicatory(vc:UIViewController) {
        activityView = UIActivityIndicatorView(style: .large)
            activityView?.center = vc.view.center
            vc.view.addSubview(activityView!)
            activityView?.startAnimating()
    }
    
    //MARK: Hide loader on controller
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
}
//MARK: App details
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
