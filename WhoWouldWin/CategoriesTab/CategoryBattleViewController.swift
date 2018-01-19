//
//  CategoryBattleViewController.swift
//  WhoWouldWin
//
//  Created by HP on 09.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategoryBattleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    var idArr = [String]()
    var battlesArr: [[String : [String : Any]]]?
    var randomIndex: Int = 0
    
    var votesContender1: Int = 0
    var votesContender2: Int = 0
    
    var categoryName: String!
    var battleCount: UInt = 0
    
    @IBOutlet weak var centerCircleView: UIView!
    @IBOutlet weak var battleCollectionView: UICollectionView!
    
//    @IBAction func nextButton(_ sender: CustomButton) {
//        vote1Button.isHidden = false
//        vote2Button.isHidden = false
//        nextButton.isHidden = true
//
//        battlesArr?.remove(at: randomIndex)
//        idArr.remove(at: randomIndex)
//        displayBattle()
//    }
//    @IBAction func vote1Button(_ sender: UIButton) {
//        votesContender1 += 1
//
//        let ID = idArr[randomIndex]
//        let battleRef = ref?.child("Categories").child(categoryName).child(ID)
//
//        battleRef?.child("Contender 1").child("Votes").setValue(votesContender1)
//
//        self.percent1Label.text = String(votesContender1)
//
//        vote1Button.isHidden = true
//        vote2Button.isHidden = true
//        nextButton.isHidden = false
//    }
//
//    @IBAction func vote2Button(_ sender: UIButton) {
//        votesContender2 += 1
//
//        let ID = idArr[randomIndex]
//        let battleRef = ref?.child("Categories").child(categoryName).child(ID)
//
//        battleRef?.child("Contender 2").child("Votes").setValue(votesContender2)
//
//        self.percent2Label.text = String(votesContender2)
//
//        vote1Button.isHidden = true
//        vote2Button.isHidden = true
//        nextButton.isHidden = false
//    }
    
    override func viewDidLayoutSubviews() {
        centerCircleView.layer.cornerRadius = centerCircleView.frame.width / 2
        centerCircleView.layer.borderWidth = 6
        let myColor : UIColor = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        centerCircleView.layer.borderColor = myColor.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ref = Database.database().reference()
//        
//        refHandle = ref?.child("Categories").child(categoryName).observe(.childAdded, with: { (snapshot) in
//            
//            print(snapshot.key)
//            if let dict = snapshot.value as? [String : [String : AnyObject]] {
//                
//                if self.battlesArr?.append(dict) == nil {
//                    self.battlesArr = [dict]
//                }
//                self.idArr.append(snapshot.key)
//            }
//            self.displayBattle()
//        })
        
        // ----- collection view:-----
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = (battleCollectionView.frame.height + 49) / 2 // 49: tab bar
        
        let customLayout = UICollectionViewFlowLayout()
        customLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        customLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        //customLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        
        customLayout.minimumLineSpacing = 20
        
        battleCollectionView.collectionViewLayout = customLayout
        
        reloadCollectionView()
        
    }
    
    func reloadCollectionView() {
        battleCollectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CatBattleCollectionViewCell
        cell.nameLabel.text = "Swift Guy"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("voted for dude")
        
    }

    func displayBattle() {
//        if let arr = battlesArr {
//            let len = arr.count
//            if len != 0 {
//                errorLabel.isHidden = true
//                randomIndex = Int(arc4random_uniform(UInt32(len)))
//
//                let dict = arr[randomIndex]
//                self.contender1Label.text = dict["Contender 1"]!["Name"] as? String
//                let votes1 = dict["Contender 1"]!["Votes"] as! Int
//                self.percent1Label.text = String(votes1)
//
//                self.contender2Label.text = dict["Contender 2"]!["Name"] as? String
//                let votes2 = dict["Contender 2"]!["Votes"] as! Int
//                self.percent2Label.text = String(votes2)
//
//                votesContender1 = votes1
//                votesContender2 = votes2
//            } else {
//                vote1Button.isHidden = true
//                vote2Button.isHidden = true
//                nextButton.isHidden = true
//                errorLabel.isHidden = false
//
//            }
//
//        }
    }

}
