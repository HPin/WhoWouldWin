//
//  CategoryBattleViewController.swift
//  WhoWouldWin
//
//  Created by HP on 09.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategoryBattleViewController: UIViewController {
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    var idArr = [String]()
    var battlesArr: [[String : [String : Any]]]?
    var randomIndex: Int = 0
    
    var votesContender1: Int = 0
    var votesContender2: Int = 0
    
    var categoryName: String!
    var battleCount: UInt = 0
    
    @IBOutlet weak var battleNameLabel: UILabel!
    @IBOutlet weak var contender1Label: UILabel!
    @IBOutlet weak var contender2Label: UILabel!
    @IBOutlet weak var percent1Label: UILabel!
    @IBOutlet weak var percent2Label: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var vote2Button: UIButton!
    @IBOutlet weak var vote1Button: UIButton!
    @IBAction func nextButton(_ sender: CustomButton) {
        vote1Button.isHidden = false
        vote2Button.isHidden = false
        nextButton.isHidden = true
        
        battlesArr?.remove(at: randomIndex)
        idArr.remove(at: randomIndex)
        displayBattle()
    }
    @IBAction func vote1Button(_ sender: UIButton) {
        votesContender1 += 1
        
        let ID = idArr[randomIndex]
        let battleRef = ref?.child("Categories").child(categoryName).child(ID)
        
        battleRef?.child("Contender 1").child("Votes").setValue(votesContender1)
        
        //battlesArr?.remove(at: randomIndex)
        self.percent1Label.text = String(votesContender1)
        
        vote1Button.isHidden = true
        vote2Button.isHidden = true
        nextButton.isHidden = false
    }
    
    @IBAction func vote2Button(_ sender: UIButton) {
        votesContender2 += 1
        
        let ID = idArr[randomIndex]
        let battleRef = ref?.child("Categories").child(categoryName).child(ID)
        
        battleRef?.child("Contender 2").child("Votes").setValue(votesContender2)
        
        battlesArr?.remove(at: randomIndex)
        displayBattle()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        refHandle = ref?.child("Categories").child(categoryName).observe(.childAdded, with: { (snapshot) in
            
            print(snapshot.key)
            if let dict = snapshot.value as? [String : [String : AnyObject]] {
                
//                guard let name1 = dict["Contender 1"]!["Name"] as? String else {return}
//                guard let votes1 = dict["Contender 1"]!["Votes"] as? Int else {return}
//                guard let name2 = dict["Contender 2"]!["Name"] as? String else {return}
//                guard let votes2 = dict["Contender 2"]!["Votes"] as? Int else {return}
//
//                let testDict = ["Contender 1" : ["Name" : name1,
//                                                "Votes" : votes1],
//                                "Contender 2" : ["Name" : name2,
//                                                 "Votes" : votes2]]
                
                if self.battlesArr?.append(dict) == nil {
                    self.battlesArr = [dict]
                }
                self.idArr.append(snapshot.key)
                
                self.displayBattle()
            }
        })

    }

    func displayBattle() {
        //print(battlesArr)
        
        if let arr = battlesArr {
            let len = arr.count
            if len != 0 {
                errorLabel.isHidden = true
                randomIndex = Int(arc4random_uniform(UInt32(len)))
                
                let dict = arr[randomIndex]
                self.contender1Label.text = dict["Contender 1"]!["Name"] as? String
                let votes1 = dict["Contender 1"]!["Votes"] as! Int
                self.percent1Label.text = String(votes1)
                
                self.contender2Label.text = dict["Contender 2"]!["Name"] as? String
                let votes2 = dict["Contender 2"]!["Votes"] as! Int
                self.percent2Label.text = String(votes2)
                
                votesContender1 = votes1
                votesContender2 = votes2
            } else {
                vote1Button.isHidden = true
                vote2Button.isHidden = true
                nextButton.isHidden = true
                errorLabel.isHidden = false
                
            }
            
        }
    }

}
