//
//  MyBattlesViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 27.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import Firebase

class MyBattlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    struct battle {
        var Contender1: String
        var Image1: String
        var Votes1: Int
        var Contender2: String
        var Image2: String
        var Votes2: Int
    }
    
    var myBattlesCat = [String: [battle]]()
    var myBattlesLoc = [String: [battle]]()
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlSwitch(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myBattlesCat = [:]
        myBattlesLoc = [:]
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        getCategories { (categories) in
            self.getUserBattlesFromCategories(uid: userUID, categories: categories, completion: { (successCat) in
                if successCat{
                    self.getLocationBattles(uid: userUID, completion: { (successLoc) in
                        if successLoc{
                          self.collectionView.reloadData()
                        }
                    })
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getLocationBattles(uid: String, completion: @escaping (Bool) -> Void){
        ref = Database.database().reference()
        ref?.child("Locations").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                if let dic = rest.value as? [String:AnyObject]{
                    if dic["user"] as? String == uid{
                        guard   let contender1 = dic["Contender 1"] as? [String:AnyObject],
                                let contender2 = dic["Contender 2"] as? [String:AnyObject],
                                let name1 = contender1["Name"] as? String,
                                let image1 = contender1["Image"] as? String,
                                let vote1 = contender1["Votes"] as? Int,
                                let name2 = contender2["Name"] as? String,
                                let vote2 = contender2["Votes"] as? Int,
                                let image2 = contender2["Image"] as? String,
                                let myCategory = dic["Category"] as? String else {return}
                        let myBattle = battle(Contender1: name1, Image1: image1, Votes1: vote1, Contender2: name2, Image2: image2, Votes2: vote2)
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
                                    let contender2 = dic["Contender 2"] as? [String:AnyObject],
                                    let name1 = contender1["Name"] as? String,
                                    let image1 = contender1["Image"] as? String,
                                    let vote1 = contender1["Votes"] as? Int,
                                    let name2 = contender2["Name"] as? String,
                                    let vote2 = contender2["Votes"] as? Int,
                                    let image2 = contender2["Image"] as? String else {return}
                            let myBattle = battle(Contender1: name1, Image1: image1, Votes1: vote1, Contender2: name2, Image2: image2, Votes2: vote2)
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0{
            let keysArray = Array(myBattlesCat.keys)
            return (myBattlesCat[keysArray[section]]?.count)!
        }
        else {
            let keysArray = Array(myBattlesLoc.keys)
            return (myBattlesLoc[keysArray[section]]?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var picturename = "cell"
        if segmentedControl.selectedSegmentIndex == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! MyBattleCollectionViewCell
            let keysArray = Array(myBattlesCat.keys)
            let contender1 = myBattlesCat[keysArray[indexPath.section]]?[indexPath.row].Contender1
            cell.contender1Label.text = contender1
            let contender2 = myBattlesCat[keysArray[indexPath.section]]?[indexPath.row].Contender2
            cell.contender2Label.text = contender2
            
            picturename.append(keysArray[indexPath.section])
            cell.categoryImageView?.image = UIImage(named: picturename)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! MyBattleCollectionViewCell
            let keysArray = Array(myBattlesLoc.keys)
            let contender1 = myBattlesLoc[keysArray[indexPath.section]]?[indexPath.row].Contender1
            cell.contender1Label.text = contender1
            let contender2 = myBattlesLoc[keysArray[indexPath.section]]?[indexPath.row].Contender2
            cell.contender2Label.text = contender2
            
            picturename.append(keysArray[indexPath.section])
            cell.categoryImageView?.image = UIImage(named: picturename)
            
            return cell
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0{
            return myBattlesCat.keys.count
        }
        else {
            return myBattlesLoc.keys.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var title = ""
        var image = "coll"
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
        
        if segmentedControl.selectedSegmentIndex == 0{
            let keysArray = Array(myBattlesCat.keys)
            title = keysArray[indexPath.section]
            image.append(title)
        }
        else {
            let keysArray = Array(myBattlesLoc.keys)
            title = keysArray[indexPath.section]
            image.append(title)
        }
        
        
        //sectionHeaderView.categoryTitle = title
        sectionHeaderView.imageName = image
         
        return sectionHeaderView
    }
    
  


}
