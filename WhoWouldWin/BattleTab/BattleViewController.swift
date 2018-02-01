//
//  ViewController.swift
//  WhoWouldWin
//
//  Created by HP on 27.12.17.
//  Copyright © 2017 HPJSVW. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BattleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerCircleView: UIView!
    @IBOutlet weak var battleCollectionView: UICollectionView!
    
   
    struct battleStruct {
        var ID: String
        var Contender1: String
        var Image1: String?
        var Votes1: Int
        var Contender2: String
        var Image2: String?
        var Votes2: Int
    }
    var randomIndexCat = 0
    var randomIndexBattle = 0
    
    var catName: String = ""
    
    var myBattlesCat = [String: [battleStruct]]()
    
    let categories = ["Fight", "Dance Battle", "Beauty Contest", "Rap Battle"]
    
    var hasVotedFor1: Bool = false
    var hasVotedFor2: Bool = false
    
    var battle:battleStruct?
    
    override func viewDidLayoutSubviews() {
        topView.layer.cornerRadius = topView.frame.width / 2
        topView.layer.borderWidth = 4
        topView.layer.borderColor = UIColor.white.cgColor
        topView.backgroundColor = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        
        centerCircleView.layer.cornerRadius = centerCircleView.frame.width / 2
        centerCircleView.layer.borderWidth = 4
        let myColor : UIColor = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        centerCircleView.layer.borderColor = myColor.cgColor
        
        let size = centerCircleView.sizeThatFits(self.view.bounds.size)
        centerCircleView.frame = CGRect.init(x: (self.view.bounds.size.width - size.width) / 2.0, y: (self.view.bounds.size.height - size.height) / 1.9 , width: size.width, height: size.height)
        
        let sizeTop = topView.sizeThatFits(self.view.bounds.size)
        topView.frame = CGRect.init(x: (self.view.bounds.size.width - sizeTop.width) / 2.0, y:(-sizeTop.height/1.5) , width: sizeTop.width, height: sizeTop.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    
        reloadCollectionView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch data from firebase and display it
        
        //----- collection view stuff:----------------
        let itemWidth = UIScreen.main.bounds.width
        let itemHeight = (battleCollectionView.frame.height + 49) / 2 // 49: tab bar
        
        let customLayout = UICollectionViewFlowLayout()
        customLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        customLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        //customLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        
        customLayout.minimumLineSpacing = 20
        
        battleCollectionView.collectionViewLayout = customLayout

        battleCollectionView.collectionViewLayout = customLayout
        myBattlesCat = [:]
        
        getCategories { (categories) in
            self.getBattlesFromCategories(categories: categories, completion: { (successCat) in
                if successCat{
                    print("yeeeeeeeeees")
                    self.displayBattle()
                }
            })
        }
        reloadCollectionView()
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
    
    
    func getBattlesFromCategories(categories: [String], completion: @escaping (Bool) -> Void){
        for index in 0..<categories.count{
            ref = Database.database().reference()
            let childName: String = categories[index]
            ref?.child("Categories").child(childName).observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot{
                    if let dic = rest.value as? [String:AnyObject]{
                        
                        guard
                            let contender1 = dic["Contender 1"] as? [String:AnyObject],
                            let contender2 = dic["Contender 2"] as? [String:AnyObject],
                            let name1 = contender1["Name"] as? String,
                            let image1 = contender1["Image"] as? String,
                            let vote1 = contender1["Votes"] as? Int,
                            let name2 = contender2["Name"] as? String,
                            let vote2 = contender2["Votes"] as? Int,
                            let image2 = contender2["Image"] as? String else {return}
                        let myBattle = battleStruct(ID: rest.key, Contender1: name1, Image1: image1, Votes1: vote1, Contender2: name2, Image2: image2, Votes2: vote2)
                        if self.myBattlesCat[snapshot.key]?.append(myBattle) == nil{
                            self.myBattlesCat[snapshot.key] = [myBattle]
                        }
                        
                    }
                }
                if index == categories.count-1{
                    completion(true)
                }
            })
        }
    }

    func displayBattle() {
        let arr = myBattlesCat
        
        let len = arr.capacity
        if len != 0 {
            //errorLabel.isHidden = true
            
            randomIndexCat = Int(arc4random_uniform(UInt32(4)))
            randomIndexBattle = Int(arc4random_uniform(UInt32(len)))
            
            let catArr = Array(arr.keys)
            let cat = catArr[randomIndexCat]
            categoryLabel.text = cat
            let dict = arr[cat]![randomIndexBattle]
            catName = cat
            
            if let name1 = dict.Contender1 as? String {
                battle!.Contender1 = name1
            }
            if let votes1 = dict.Votes1 as? Int {
                battle!.Votes1 = votes1
            }
            if let imgURL1 = dict.Image1 as? String {
                battle!.Image1 = imgURL1
            }
            
            if let name2 = dict.Contender2 as? String {
                battle!.Contender2 = name2
            }
            if let votes2 = dict.Votes2 as? Int {
                battle!.Votes2 = votes2
            }
            if let imgURL2 = dict.Votes1 as? String {
                battle!.Image2 = imgURL2
            }
            
            if let id = dict.ID as? String {
                battle!.ID = id
            }
            
            reloadCollectionView()
        } else {
            //                vote1Button.isHidden = true
            //                vote2Button.isHidden = true
            //                nextButton.isHidden = true
            //                errorLabel.isHidden = false
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
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BattleVCCollectionViewCell
        
        var name = "empty"
        cell.contenderImageView.image = UIImage(named: "fight.jpg")   // provide a default image
        cell.blackOverlay.alpha = 1
        
        if indexPath.row == 0 {
            //cell.contenderImageView.transform = CGAffineTransform(translationX: 0, y: -400)
            if let _battle = battle {
                name = _battle.Contender1
                
                if let imgURLString = _battle.Image1 {
                    
                    let url = URL(string: imgURLString)
                    print(imgURLString)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {   // if download not successful, close url session
                            print(error)
                            return
                        }
                        
                        DispatchQueue.main.async {  // get main UI thread
                            cell.contenderImageView.image = UIImage(data: data!)
                            UIView.animate(withDuration: 0.5, animations: {
                                cell.blackOverlay.alpha = 0.35
                            })
                        }
                        
                    }).resume()
                }
            }
        }
        if indexPath.row == 1 {
            
            
            if let _battle = battle {
                name = _battle.Contender1
                
                if let imgURLString = _battle.Image1 {
            
                    
                    let url = URL(string: imgURLString)
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {   // if download not successful, close url session
                            print(error)
                            return
                        }
                        
                        DispatchQueue.main.async {  // get main UI thread
                            cell.contenderImageView.image = UIImage(data: data!)
                            UIView.animate(withDuration: 0.5, animations: {
                                cell.blackOverlay.alpha = 0.35
                            })
                        }
                        
                    }).resume()
                }
            }
        }
        cell.nameLabel.text = name
        
        
        
        if hasVotedFor1 {
            if indexPath.row == 0 {
                cell.blackOverlay.backgroundColor = UIColor.green
            }
            if indexPath.row == 1 {
                cell.blackOverlay.backgroundColor = UIColor.red
            }
        } else if hasVotedFor2 {
            if indexPath.row == 0 {
                cell.blackOverlay.backgroundColor = UIColor.red
            }
            if indexPath.row == 1 {
                cell.blackOverlay.backgroundColor = UIColor.green
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
            cell.blackOverlay.backgroundColor = UIColor.black
        }
        
        return cell
    }
    
    
    func calcPercent() -> Double {
        // catch corner cases (div 0 errors)
        if battle!.Votes1 == battle!.Votes2 {
            return 50
        }
        if battle!.Votes1 != 0 && battle!.Votes2 == 0 {
            return 100
        }
        if battle!.Votes1 == 0 && battle!.Votes2 != 0 {
            return 0
        }
        
        // regular case: return percent of c1...(votes/totalvotes*100)
        let percent = battle!.Votes1 / (battle!.Votes1 + battle!.Votes2) * 100
        let rounded = round(Double(10 * percent)) / 10
        return rounded
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _battle = battle{
        
            if indexPath.row == 0 {
                battle!.Votes1 += 1
                
                
                let battleRef = ref?.child("Categories").child(catName).child(_battle.ID)
                
                battleRef?.child("Contender 1").child("Votes").setValue(battle!.Votes1)
                
                hasVotedFor1 = true
                hasVotedFor2 = false
                
                reloadCollectionView()
                loadNextBattle()
                
            }
            if indexPath.row == 1 {
                battle!.Votes2 += 1
                
                
                let battleRef = ref?.child("Categories").child(catName).child(_battle.ID)
                
                battleRef?.child("Contender 2").child("Votes").setValue(battle!.Votes2)
                
                hasVotedFor2 = true
                hasVotedFor1 = false
                
                reloadCollectionView()
                loadNextBattle()
            }
        }
    }
    
    func loadNextBattle() {
        
        UIView.animate(withDuration: 0.3, delay: 5, options: .curveEaseIn, animations: {
            self.battleCollectionView.transform = CGAffineTransform(translationX: -800, y: 0)
        }, completion: { (finished) in
            self.hasVotedFor1 = false
            self.hasVotedFor2 = false
            
            self.myBattlesCat[self.catName]?.remove(at: self.randomIndexBattle)
            self.displayBattle()
            
            self.battleCollectionView.transform = CGAffineTransform(translationX: 800, y: 0)
            UIView.animate(withDuration: 0.25, animations: {
                self.battleCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        })
        
    }
}

