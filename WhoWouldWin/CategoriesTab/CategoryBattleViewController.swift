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
    
    var categoryName: String!
    var battleCount: UInt = 0
    
    @IBOutlet weak var battleNameLabel: UILabel!
    @IBOutlet weak var contender1Label: UILabel!
    @IBOutlet weak var contender2Label: UILabel!
    @IBOutlet weak var percent1Label: UILabel!
    @IBOutlet weak var percent2Label: UILabel!
    
    @IBAction func nextButton(_ sender: CustomButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let random = Int(arc4random_uniform(2))
        let battleID = categoryName + " " + String(random)
        
        refHandle = ref?.child("Categories").child(categoryName).observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            print("--------------")
            
            if let dict = snapshot.value as? [String : [String : AnyObject]] {
                self.contender1Label.text = dict["Contender 1"]!["Name"] as? String
                let percent1 = dict["Contender 1"]!["Votes"] as! Int
                self.percent1Label.text = String(percent1)

                self.contender2Label.text = dict["Contender 2"]!["Name"] as? String
                let percent2 = dict["Contender 2"]!["Votes"] as! Int
                self.percent2Label.text = String(percent2)
            }
        })
        
//        refHandle = ref?.child("Categories").child(categoryName).child(battleID).observe(.value, with: { (snapshot) in
//
//            print(snapshot)
//
//            if let dict = snapshot.value as? [String : [String : AnyObject]] {
//
//                self.contender1Label.text = dict["Contender 1"]!["Name"] as? String
//                let percent1 = dict["Contender 1"]!["Votes"] as! Int
//                self.percent1Label.text = String(percent1)
//
//                self.contender2Label.text = dict["Contender 2"]!["Name"] as? String
//                let percent2 = dict["Contender 2"]!["Votes"] as! Int
//                self.percent2Label.text = String(percent2)
//            }
//
////            self.battleNameLabel.text = "abc"
////
////            if let dict = snapshot.value as? [String : AnyObject] {
////                self.contender1Label.text = dict["Name"] as? String
////                self.percent1Label.text = dict["Percentage"] as? String
////            }
//        })

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
