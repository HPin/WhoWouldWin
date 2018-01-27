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
    
    let sections = ["Profile","Team"]
    let cellLabels = [["User","Battlescollection"], ["About", "Contact"]]
    
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
    

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        let userUID = Auth.auth().currentUser?.uid
        getUsernameFromUID(uid: userUID!) { (userName) in
             print(userName)
            self.usernameLabel.text = userName
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
