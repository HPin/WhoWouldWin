//
//  SettingsViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 27.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var settingsTableView: UITableView!
    
    let sections = ["Profile","Team"]
    let cellLabels = [["User","My Battles"], ["About", "Contact"]]
    
    
    override func viewWillAppear(_ animated: Bool) {
        if self.userImage.image == nil {
            let imageName = UIImage(named: "Wait")
            self.userImage?.image = imageName
        }
        print("ViewwillApear")
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        getNumberOfBattles(uid: userUID) { (numberOfBattles) in
            let numberBattles = Int(numberOfBattles)
            
            if numberBattles < 10 {
                let imageName = UIImage(named: "Beginner")
                UIView.transition(with: self.userImage, duration: 0.5, options: .transitionFlipFromTop,animations:{ self.userImage.image = imageName } , completion: nil)
            }
            else if numberBattles >= 10 && numberBattles < 25 {
                let imageName = UIImage(named: "Advanced")
                UIView.transition(with: self.userImage, duration: 0.5, options: .transitionFlipFromTop,animations:{ self.userImage.image = imageName } , completion: nil)
            }
            else if numberBattles >= 25 && numberBattles < 45 {
                let imageName = UIImage(named: "Profi")
                UIView.transition(with: self.userImage, duration: 0.5, options: .transitionFlipFromTop,animations:{ self.userImage.image = imageName } , completion: nil)
            }
            else if numberBattles >= 45 {
                let imageName = UIImage(named: "Expert")
                UIView.transition(with: self.userImage, duration: 0.5, options: .transitionFlipFromTop,animations:{ self.userImage.image = imageName } , completion: nil)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")

    }
    //        let userUID = Auth.auth().currentUser?.uid
    //        getUsernameFromUID(uid: userUID!) { (userName) in
    //             print(userName)
    //            self.usernameLabel.text = userName
    //        }
    
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
    
    
    
    
//    func getUsernameFromUID(uid: String, completion: @escaping (String) -> Void) {
//        ref = Database.database().reference()
//        ref?.child("Users").observeSingleEvent(of: .value) { (snapshot) in
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? DataSnapshot{
//                if let dic = rest.value as? [String:AnyObject]{
//                    if dic["uid"] as? String == uid{
//                        completion(dic["name"] as! String)
//                    }
//                }
//            }
//        }
//    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sign out", message: "Do you really want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "fromSettingsToLogin", sender: self)
            } catch let logOutError {
                print(logOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellLabels[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        cell.textLabel?.text = cellLabels[indexPath.section][indexPath.row]
        
        let imageName = UIImage(named: cellLabels[indexPath.section][indexPath.row])
        cell.imageView?.image = imageName
        
        return cell
    }

}
