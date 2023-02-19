//
//  ViewController.swift
//  Author's name : Amrik Singh
//  StudentID : 301296257
//
//  Slot Machine Part 1
//
//  Created by Amrik on 21/01/23.
// Version: 1.1

import UIKit
import  FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Variables and connections
    @IBOutlet weak var realPickerView: UIPickerView!
    {
        didSet {
            self.realPickerView.delegate = self
            self.realPickerView.dataSource = self
        }
    }
    @IBOutlet weak var betStepper: UIStepper!
    @IBOutlet weak var lblBetResult: UILabel!
    @IBOutlet weak var lblBetRisk: UILabel!
    @IBOutlet weak var lblCurrentCash: UILabel!
    @IBOutlet weak var btnSpin: UIButton!
    @IBOutlet weak var imgSpin: UIImageView!
    var isFromSignup = Bool()
    let reelImgArr = [UIImage(named: "bell"),UIImage(named: "leaf"),UIImage(named: "heart"),UIImage(named: "seven"),UIImage(named: "dice")]
    var ref = DatabaseReference()
    let newUserInfo = Auth.auth().currentUser
    // Bet amount
    var betAmount: Int = 10 {
        didSet{ //Update ui for bet label
            lblBetRisk.text = "\(currentMoney)$"
        }
    }
    
    // get current displayed cash, remove '$'
    var currentMoney: Int{
        guard let cash = lblCurrentCash.text, !(lblCurrentCash.text?.isEmpty)! else { return 0 }
        return Int(cash.replacingOccurrences(of: "$", with: ""))!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
        decorate(stepper: betStepper)
       // UpdateFirebase(wallet: currentMoney, wins: 0)
       
        getCurrentUserInfo()
    }
    
    func getCurrentUserInfo() {
        self.ref = Database.database().reference()
       ref.child("users/\(newUserInfo?.uid ?? "")").observeSingleEvent(of: .value, with: { (snapshot) in
        if let id = snapshot.value  {
        print("The value from the database: \(id)")
        }
        })
        
    }
    
    func UpdateFirebase(wallet: Int, wins: Int) {
        self.ref = Database.database().reference()
        self.ref.child("users/\(newUserInfo?.uid ?? "")").updateChildValues(["wallet": wallet,"wins": wins]){
            (error:Error?, ref:DatabaseReference) in
            
        }
        
    }

    
    
    
    //MARK: customize stepper Appearence
    func decorate(stepper: UIStepper) {
        let colorNormal = UIColor(red: 230/255, green: 179/255, blue: 37/255, alpha: 1.0)
        let colorHighlighted = UIColor(red: 147/255, green: 1/255, blue: 0/255, alpha: 1.0)
        let colorDisabled = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        
        // adjust size to your liking
        let fnt = UIFont.systemFont(ofSize: 32)
        let configuration = UIImage.SymbolConfiguration(font: fnt)
        // Left stepper button
        let lArrow = UIImage(systemName: "minus", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
        let leftNormal = lArrow?.withTintColor(colorNormal)
        let leftHighlighted = lArrow?.withTintColor(colorHighlighted)
        let leftDisabled = lArrow?.withTintColor(colorDisabled)
        // Right stepper button
        let rArrow = UIImage(systemName: "plus", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
        let rightNormal = rArrow?.withTintColor(colorNormal)
        let rightHighlighted = rArrow?.withTintColor(colorHighlighted)
        let rightDisabled = rArrow?.withTintColor(colorDisabled)
        let blank = UIImage()
        
        stepper.setDecrementImage(leftNormal, for: .normal)
        stepper.setDecrementImage(leftHighlighted, for: .highlighted)
        stepper.setDecrementImage(leftDisabled, for: .disabled)
        
        stepper.setIncrementImage(rightNormal, for: .normal)
        stepper.setIncrementImage(rightHighlighted, for: .highlighted)
        stepper.setIncrementImage(rightDisabled, for: .disabled)
        
        stepper.setBackgroundImage(blank, for: .normal)
        stepper.setDividerImage(blank, forLeftSegmentState: .normal, rightSegmentState: .normal)
    }
    
    //MARK: Module to check if user has jackpot
    func inspectWin() {
        var lastRow = -1
        var counter = 0
        for index in 0 ..< realPickerView.numberOfComponents {
            let row : Int = realPickerView.selectedRow(inComponent: index) % reelImgArr.count // selected img index
            if lastRow == row{ // two equals indexes
                counter += 1
            } else {
                lastRow = row
                counter = 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.betResult(count: counter)
        }
    }
    
    func betResult(count:Int)  {
        if count == 3 { // winning
            betStepper.maximumValue = Double(currentMoney)
            lblBetResult.text = "YOU WON \(200 + betAmount * 2)$"
            lblCurrentCash.text = "\(Int(currentMoney + 200) + (betAmount * 2))$"
            //Open celebration controller
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CongratulationVC") as! CongratulationVC
            vc.amount = "YOU WON \(200 + betAmount * 2)$"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        } else { // losing
            Utility.shared.play(sound: "lossbet",ext: "wav")
            lblBetResult.text = "TRY AGAIN"
            lblCurrentCash.text = "\(Int(currentMoney - betAmount))$"
        }
        if currentMoney <= 0 {
            btnSpin.isEnabled = false
            imgSpin.alpha = 0.6 // disapper spin clicking
            Utility.shared.displayPopup(title: "Sorry!", msg: "You have \(currentMoney)$ in wallet.\nPress Reset to continue game.", VC: self)  // no cash
        } else {  // update bet stepper
            if Int(betStepper.value) > currentMoney {
                betStepper.maximumValue = Double(currentMoney)
                betAmount = currentMoney
                betStepper.value = Double(currentMoney)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.00) {
            self.lblBetResult.text = ""
        }
    }
        
    //MARK: button Spin Action Handler
    @IBAction func btnSpinAction(_ sender: UIButton) {
        Utility.shared.play(sound: "Spin")
        btnSpin.isUserInteractionEnabled = false // disable clicking
        self.lblBetResult.text = ""
        for index in 0..<realPickerView.numberOfComponents{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30, execute: {
                let random = Int(arc4random_uniform(UInt32(8 * self.reelImgArr.count))) + self.reelImgArr.count
                self.realPickerView.selectRow(random, inComponent: index, animated: true)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.inspectWin()
            self.btnSpin.isUserInteractionEnabled = true
        }
    }
    
    //Increase Decrease bet amount Stepper
    @IBAction func betAmountStepper(_ sender: UIStepper) {
        Utility.shared.play(sound: "bet")
        betStepper.maximumValue = Double(currentMoney)
        let amount = Int(sender.value)
        if currentMoney >= amount{
            betAmount = amount
            lblBetRisk.text = "\(amount)$"
        }
    }
    
    //Button reset slot machine action
    @IBAction func btnResetMachineAct(_ sender: UIButton) {
        resetGame()
    }
    
    // Reset slot machine
    func resetGame() {
        btnSpin.isEnabled = true
        imgSpin.alpha = 1 // Show spin clicking
        lblCurrentCash.text = "500$"
        betStepper.maximumValue = Double(currentMoney)
    }
    
    // Stop slot machine
    @IBAction func btnQuitMachineAct(_ sender: UIButton) {
        btnSpin.isEnabled = false
        imgSpin.alpha = 0.6 // Disapper spin clicking
        Utility.shared.displayPopup(title: "Quit game", msg: "You have \(currentMoney)$ in wallet.\nPress Reset to continue game.", VC: self)
    }
    
    //MARK: - UIPickerView Data source and delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reelImgArr.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % reelImgArr.count
        return UIImageView(image: reelImgArr[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return (reelImgArr[component]?.size.height ?? 0) + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
    }
}
