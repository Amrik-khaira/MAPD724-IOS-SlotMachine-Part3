//  CongratulationVC.swift
//  Author's name : Amrik Singh
//  StudentID : 301296257
//
//  Slot Machine Part 2
//
//  Created by Amrik on 04/02/23.
//
// Version: 2.0


import UIKit
import SpriteKit

class CongratulationVC: UIViewController {
    //Outlets and variables
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var spriteViw: SKView!
    @IBOutlet weak var lblWinings: UILabel!
    var amount = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.shared.play(sound: "win") //Wining sound
        //Sprite kit animation present on view
        if let view = self.spriteViw {
            // Load the SKScene from 'WiningScene.sks'
            let scene: WiningScene = WiningScene(size: self.view.frame.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
        lblWinings.text = amount + ". Tap on continue to win again."
        popupView.alpha = 0
        popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            //Popin animation!
            UIView.animate(
                withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                options: .curveEaseOut, animations: {
                    self.popupView.transform = .identity
                    self.popupView.alpha = 1
                }) { _ in
                    //Popout animation
                    UIView.animate(
                        withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                        options: .curveEaseOut, animations: {
                            self.popupView.alpha = 0
                            self.popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        }, completion: nil)
                }
        }
    }
    
    @IBAction func btnBackAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
