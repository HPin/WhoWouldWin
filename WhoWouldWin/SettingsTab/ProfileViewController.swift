//
//  ProfileViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 28.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var usermail: UILabel!
    @IBOutlet weak var usercount: UILabel!
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    
    override func viewWillAppear(_ animated: Bool) {
        usermail.text = Auth.auth().currentUser?.email
        guard let userUID = Auth.auth().currentUser?.uid else {return}
            getUsernameFromUID(uid: userUID) { (userName) in
                self.username.text = userName
            }
        getNumberOfBattles(uid: userUID) { (numberOfBattles) in
            let numberBattles = Int(numberOfBattles)
            self.usercount.text = String(numberBattles)
        }
    }
    
    func getNumberOfBattles(uid: String, completion: @escaping (UInt) -> Void){
        ref = Database.database().reference()
        ref?.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                if let dic = rest.value as? [String:AnyObject]{
                    if dic["uid"] as? String == uid{
                        if (dic["battles"] != nil) {
                            guard let numberOfBattles = dic["battles"]?.childrenCount else {return}
                            completion(numberOfBattles)
                        } else {
                            completion(0)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = UIImage(named: "Profile")
        profileImageView?.image = imageName
        profileImageView.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    
    

        func getUsernameFromUID(uid: String, completion: @escaping (String) -> Void) {
            ref = Database.database().reference()
            ref?.child("Users").observeSingleEvent(of: .value) { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot{
                    if let dic = rest.value as? [String:AnyObject]{
                        if dic["uid"] as? String == uid{
                            completion(dic["name"] as! String)
                        }
                    }
                }
            }
        }

}
