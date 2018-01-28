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
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerCircleView: UIView!
    @IBOutlet weak var battleCollectionView: UICollectionView!
    
    
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
        getData { (display) in
            if display {
                self.displayBattle()
            }
        }

        //----- collection view:----------------
        let itemSize = UIScreen.main.bounds.width / 2 - 4   // - x means x pts spacing
        
        let customLayout = UICollectionViewFlowLayout()
        customLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        customLayout.itemSize = CGSize(width: itemSize, height: view.bounds.height)
        //customLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        
        customLayout.minimumInteritemSpacing = 4
        //customLayout.minimumLineSpacing = 20
        
        battleCollectionView.collectionViewLayout = customLayout
        
        reloadCollectionView()
    }
    

    func getData(completion: @escaping (Bool) -> Void){
        
        var display = true
        
//        ref = Database.database().reference()
//        ref?.child("Categories").observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot)
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? DataSnapshot {
//                if let dict = rest.value as? [String:AnyObject] {
//                    print(dict)
//
//                    if self.locationIsInRange(myLocation: location, surveyLocation: location1){
//                        print("There is a fight in your location")
//                        if self.battlesArr?.append(dict) == nil {
//                            self.battlesArr = [dict]
//                        }
//                        self.idArr.append(rest.key)
//                    }
//                    else {
//                        print("There is no fight in your location")
//                        display = false
//                    }
//                }
//            }
//            completion(display)
//        })
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
//                self.percentage1Label.text = String(votes1)
//
//                self.contender2Label.text = dict["Contender 2"]!["Name"] as? String
//                let votes2 = dict["Contender 2"]!["Votes"] as! Int
//                self.percentage2Label.text = String(votes2)
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
        cell.nameLabel.text = "Swift Guy"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("voted for dude")
        
    }
}

