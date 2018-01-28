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
    
    struct battle {
        var Contender1: String
        var Contender2: String
        var Votes1: Int
        var Votes2: Int
    }
    
    var myBattlesCat = [String: [battle]]()
    var myBattlesLoc = [String: [battle]]()
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    @IBOutlet weak var battlesViewImage: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        getCategories { (categories) in
            self.getUserBattlesFromCategories(uid: userUID, categories: categories, completion: { (successCat) in
                if successCat{
                    self.getLocationBattles(uid: userUID, completion: { (successLoc) in
                        if successLoc{
                            print("--------------------")
                            print("--------------------")
                            print(self.myBattlesCat)
                            print("--------------------")
                            print(self.myBattlesLoc)
                            print("--------------------")
                            print("--------------------")
                            print("--------------------")
                        }
                    })
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = UIImage(named: "settingsmybattle")
        battlesViewImage?.image = imageName
        battlesViewImage.layer.cornerRadius = 20
    }
    
    func getLocationBattles(uid: String, completion: @escaping (Bool) -> Void){
        ref = Database.database().reference()
        ref?.child("Locations").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                if let dic = rest.value as? [String:AnyObject]{
                    if dic["user"] as? String == uid{
                        guard   let contender1 = dic["Contender 1"] as? [String:AnyObject],
                            let contender2 = dic["Contender 1"] as? [String:AnyObject],
                            let name1 = contender1["Name"] as? String,
                            let name2 = contender2["Name"] as? String,
                            let vote1 = contender1["Votes"] as? Int,
                            let vote2 = contender2["Votes"] as? Int,
                            let myCategory = dic["Category"] as? String else {return}
                        let myBattle = battle(Contender1: name1, Contender2: name2, Votes1: vote1, Votes2: vote2)
                        if self.myBattlesLoc[myCategory]?.append(myBattle) == nil{
                            self.myBattlesLoc[myCategory] = [myBattle]
                        }
                    }
                }
            }
            completion(true)
        })
    }
    
    
    func getCategories(completion: @escaping ([String]) -> Void){
        var myCategories = [String]()
        ref = Database.database().reference()
        ref?.child("Categories").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                if let categorie = rest.key as? String{
                    myCategories.append(categorie)
                }
            }
            completion(myCategories)
        })
    }
    
    func getUserBattlesFromCategories(uid: String,categories: [String], completion: @escaping (Bool) -> Void){
        for index in 0..<categories.count{
            ref = Database.database().reference()
            let childName: String = categories[index]
            ref?.child("Categories").child(childName).observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot{
                    if let dic = rest.value as? [String:AnyObject]{
                        if dic["user"] as? String == uid{
                            guard   let contender1 = dic["Contender 1"] as? [String:AnyObject],
                                    let contender2 = dic["Contender 1"] as? [String:AnyObject],
                                    let name1 = contender1["Name"] as? String,
                                    let name2 = contender2["Name"] as? String,
                                    let vote1 = contender1["Votes"] as? Int,
                                    let vote2 = contender2["Votes"] as? Int else {return}
                            let myBattle = battle(Contender1: name1, Contender2: name2, Votes1: vote1, Votes2: vote2)
                            if self.myBattlesCat[snapshot.key]?.append(myBattle) == nil{
                                self.myBattlesCat[snapshot.key] = [myBattle]
                            }
                        }
                    }
                }
                if index == categories.count-1{
                    completion(true)
                }
            })
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
