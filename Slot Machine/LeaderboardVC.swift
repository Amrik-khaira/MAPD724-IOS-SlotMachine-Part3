//
//  LeaderboardVC.swift
//  Author's name : Amrik Singh
//  StudentID : 301296257
//
//  Slot Machine Part 3
//
//  Created by Amrik on 18/02/23.
// Version: 1.3

import UIKit
import  FirebaseDatabase
import FirebaseAuth

class LeaderboardVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    //outlet and connections
    var ref = DatabaseReference()
    @IBOutlet weak var tblViewUserRank: UITableView!
    var userList = [users]()
    
    //MARK: get all user data and parse in codeable
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        Utility.shared.showActivityIndicatory(vc: self)
            self.ref = Database.database().reference()
           ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
               for child in snapshot.children {
                   let key = (child as AnyObject).key as String
                   let dict = snapshot.value as? [String:Any]
                   let obj = dict?[key] as? [String:Any]
                   self.userList.append(users(username: obj?["username"] as? String, wings: obj?["wins"] as? Int, wallet:obj?["wallet"] as? Int, email:obj?["email"] as? String,userId: obj?["userId"] as? String))
                   }
               
               self.userList = self.userList.sorted { $0.wings ?? 0  > $1.wings ?? 0 }
               self.tblViewUserRank.reloadData()
               Utility.shared.hideActivityIndicator()
            })
        
    }
    //MARK: - btn Back button Act
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    //MARK: - tableView datasource and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        
        let objuser = userList[indexPath.row]
        cell.lblName.text = "\(objuser.username ?? "")  Rank:\(indexPath.row + 1) "
        cell.lblCash.text = "Winings: \(objuser.wings ?? 0) $"
       
        if Auth.auth().currentUser?.uid == objuser.userId
        {
            cell.lblWins.text = "Wallet: \(objuser.wallet ?? 0) $"
            cell.ViewBack?.backgroundColor = .green
        } else{
            cell.lblWins.text = "Email: \(objuser.email ?? "")"
            cell.ViewBack?.backgroundColor = .white
        }
        return cell
    }
}

//MARK: - TableView Show Shop Cell class
class UserCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblWins: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var ViewBack: UIView!
}


//MARK: - Json Structure for handel data
struct users:Codable {
    var username : String?
    var wings : Int?
    var wallet : Int?
    var email : String?
    var userId : String?
}
