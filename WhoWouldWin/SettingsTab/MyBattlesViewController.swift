//
//  MyBattlesViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 27.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import Firebase

class MyBattlesViewController: UIViewController {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    @IBOutlet weak var battlesViewImage: UIImageView!
    var names = [Int:[String]]()
    var votes = [Int:[Int]]()
    var battlesIDs = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = UIImage(named: "settingsmybattle")
        battlesViewImage?.image = imageName
        battlesViewImage.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        getNumberOfBattles(uid: userUID) { (key, numberBattles) in
            self.ref = Database.database().reference()
            self.ref?.child("Users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot{
                    if let dic = rest.value as? [String:String]{
                        for (key,value) in dic{
                            self.battlesIDs.append(value)
                        }
                    }
                }
            })
        }
    }
    

    func getNumberOfBattles(uid: String, completion: @escaping (String,UInt) -> Void){
        ref = Database.database().reference()
        ref?.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                if let dic = rest.value as? [String:AnyObject]{
                    if dic["uid"] as? String == uid{
                        if (dic["battles"] != nil) {
                            guard let numberOfBattles = dic["battles"]?.childrenCount else {return}
                            completion(rest.key,numberOfBattles)
                        } else {
                            print("No battles")
                        }
                    }
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
