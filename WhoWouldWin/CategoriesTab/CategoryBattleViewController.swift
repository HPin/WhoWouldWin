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
    var battlesArr:[[String:AnyObject]]?
//    var battlesArr: [[String : [String : Any]]]?
    var randomIndex: Int = 0
    
    var nameContender1: String = ""
    var nameContender2: String = ""
    var votesContender1: Double = 0
    var votesContender2: Double = 0
    var imageURLContender1: String?
    var imageURLContender2: String?
    
    var categoryName: String!
    var battleCount: UInt = 0
    
    var hasVotedFor1: Bool = false
    var hasVotedFor2: Bool = false
    
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
        
        // fetch data from firebase and display it
        getData { (display) in
            if display {
                self.displayBattle()
            }
        }
        
        //----- collection view stuff:----------------
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
    
    func getData(completion: @escaping (Bool) -> Void){
        
        var display = true
        
        ref = Database.database().reference()
        ref?.child("Categories").child(categoryName).observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if let dict = rest.value as? [String:AnyObject] {
        
                    if self.battlesArr?.append(dict) == nil {   // if array is empty
                        self.battlesArr = [dict]    // initialize it
                    }
                    self.idArr.append(rest.key)
                }
            }
            completion(display)
        })
    }
    
    func displayBattle() {
        if let arr = battlesArr {
            let len = arr.count
            if len != 0 {
                //errorLabel.isHidden = true
                randomIndex = Int(arc4random_uniform(UInt32(len)))
                
                let dict = arr[randomIndex]
                
                if let name1 = dict["Contender 1"]!["Name"] as? String {
                    nameContender1 = name1
                }
                if let votes1 = dict["Contender 1"]!["Votes"] as? Double {
                    votesContender1 = votes1
                }
                if let imgURL1 = dict["Contender 1"]!["Image"] as? String {
                    imageURLContender1 = imgURL1
                }
                
                if let name2 = dict["Contender 2"]!["Name"] as? String {
                    nameContender2 = name2
                }
                if let votes2 = dict["Contender 2"]!["Votes"] as? Double {
                    votesContender2 = votes2
                }
                if let imgURL2 = dict["Contender 2"]!["Image"] as? String {
                    imageURLContender2 = imgURL2
                }
                
                reloadCollectionView()
            } else {
//                vote1Button.isHidden = true
//                vote2Button.isHidden = true
//                nextButton.isHidden = true
//                errorLabel.isHidden = false
            }
            
        }
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
        
        var name = "empty"
        cell.contenderImageView.image = UIImage(named: "fight.jpg")   // provide a default image
        cell.colorOverlay.alpha = 1
        
        if indexPath.row == 0 {
            //cell.contenderImageView.transform = CGAffineTransform(translationX: 0, y: -400)
            
            name = nameContender1
            
            if let imgURLString = imageURLContender1 {
                
                let url = URL(string: imgURLString)
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if error != nil {   // if download not successful, close url session
                        print(error)
                        return
                    }
                    
                    DispatchQueue.main.async {  // get main UI thread
                        cell.contenderImageView.image = UIImage(data: data!)
                        UIView.animate(withDuration: 0.5, animations: {
                            cell.colorOverlay.alpha = 0.35
                        })
                    }
                    
                }).resume()
            }
        }
        if indexPath.row == 1 {
            name = nameContender2

            print(imageURLContender2)
            
            if let imgURLString = imageURLContender2 {

                let url = URL(string: imgURLString)
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                    if error != nil {   // if download not successful, close url session
                        print(error)
                        return
                    }

                    DispatchQueue.main.async {  // get main UI thread
                        cell.contenderImageView.image = UIImage(data: data!)
                        UIView.animate(withDuration: 0.5, animations: {
                            cell.colorOverlay.alpha = 0.35
                        })
                    }

                }).resume()
            }
        }
        cell.nameLabel.text = name
        
        
        
        if hasVotedFor1 {
            if indexPath.row == 0 {
                cell.colorOverlay.backgroundColor = UIColor.green
            }
            if indexPath.row == 1 {
                cell.colorOverlay.backgroundColor = UIColor.red
            }
        } else if hasVotedFor2 {
            if indexPath.row == 0 {
                cell.colorOverlay.backgroundColor = UIColor.red
            }
            if indexPath.row == 1 {
                cell.colorOverlay.backgroundColor = UIColor.green
            }
        }
        
        if hasVotedFor1 || hasVotedFor2 {
            let percent1 = calcPercent()
            if indexPath.row == 0 {
                cell.percentLabel.text = String(percent1) + "\n%"
            }
            if indexPath.row == 1 {
                cell.percentLabel.text = String(100 - percent1)  + "\n%"
            }
            cell.percentLabel.isHidden = false
        } else {
            // reset cell
            cell.percentLabel.isHidden = true
            cell.colorOverlay.backgroundColor = UIColor.black
        }
        
        return cell
    }
    
    func calcPercent() -> Double {
        // catch corner cases (div 0 errors)
        if votesContender1 == votesContender2 {
            return 50
        }
        if votesContender1 != 0 && votesContender2 == 0 {
            return 100
        }
        if votesContender1 == 0 && votesContender2 != 0 {
            return 0
        }

        // regular case: return percent of c1...(votes/totalvotes*100)
        let percent = votesContender1 / (votesContender1 + votesContender2) * 100
        let rounded = round(10 * percent) / 10
        return rounded
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            votesContender1 += 1
            
            let ID = idArr[randomIndex]
            let battleRef = ref?.child("Categories").child(categoryName).child(ID)
            
            battleRef?.child("Contender 1").child("Votes").setValue(votesContender1)
            
            hasVotedFor1 = true
            hasVotedFor2 = false
            
            reloadCollectionView()
            loadNextBattle()
            
        }
        if indexPath.row == 1 {
            votesContender2 += 1
            
            let ID = idArr[randomIndex]
            let battleRef = ref?.child("Categories").child(categoryName).child(ID)
            
            battleRef?.child("Contender 2").child("Votes").setValue(votesContender2)
            
            hasVotedFor2 = true
            hasVotedFor1 = false
            
            reloadCollectionView()
            loadNextBattle()
        }
    }
    
    
    
    
    func loadNextBattle() {
        
        UIView.animate(withDuration: 0.3, delay: 5, options: .curveEaseIn, animations: {
            self.battleCollectionView.transform = CGAffineTransform(translationX: -800, y: 0)
        }, completion: { (finished) in
            self.hasVotedFor1 = false
            self.hasVotedFor2 = false
            
            self.battlesArr?.remove(at: self.randomIndex)
            self.idArr.remove(at: self.randomIndex)
            self.displayBattle()
            
            self.battleCollectionView.transform = CGAffineTransform(translationX: 800, y: 0)
            UIView.animate(withDuration: 0.25, animations: {
                self.battleCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        })
    
    }

//    func displayBattle() {
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
//    }

}
