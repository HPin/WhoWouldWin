//
//  LocationBattleViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 10.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class LocationBattleViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var percentage2Label: UILabel!
    @IBOutlet weak var contender1Label: UILabel!
    @IBOutlet weak var contender2Label: UILabel!
    @IBOutlet weak var percentage1Label: UILabel!
    @IBOutlet weak var vote1Button: UIButton!
    @IBOutlet weak var vote2Button: UIButton!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref: DatabaseReference?
    var loc: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    let manager = CLLocationManager()
    var locationRadius:Double = 10
    
    var idArr = [String]()
    var battlesArr:[[String:AnyObject]]?
    var randomIndex: Int = 0
    var votesContender1: Int = 0
    var votesContender2: Int = 0

    
    @IBAction func nextButton(_ sender: Any) {
        vote1Button.isHidden = false
        vote2Button.isHidden = false
        nextButton.isHidden = true
        
        battlesArr?.remove(at: randomIndex)
        idArr.remove(at: randomIndex)
        displayBattle()
    }
    
    @IBAction func vote1Button(_ sender: Any) {
        votesContender1 += 1

        let ID = idArr[randomIndex]
        let battleRef = ref?.child("Locations").child(ID)

        battleRef?.child("Contender 1").child("Votes").setValue(votesContender1)

        self.percentage1Label.text = String(votesContender1)

        vote1Button.isHidden = true
        vote2Button.isHidden = true
        nextButton.isHidden = false
    }
    @IBAction func vote2Button(_ sender: Any) {
        votesContender2 += 1

        let ID = idArr[randomIndex]
        let battleRef = ref?.child("Locations").child(ID)

        battleRef?.child("Contender 2").child("Votes").setValue(votesContender2)

        self.percentage2Label.text = String(votesContender2)

        vote1Button.isHidden = true
        vote2Button.isHidden = true
        nextButton.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        guard let myLocation:CLLocation = manager.location else {
            print("Couldn't get current location!")
            return
        }
        let myLatitude = myLocation.coordinate.latitude
        let myLongitude = myLocation.coordinate.longitude
        
        
        ref = Database.database().reference()
        refHandle = ref?.child("Locations").observe(.value, with: { (snapshot) in
            print(snapshot)
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if let dic = rest.value as? [String:AnyObject] {
                    print(dic)
                    let latitude:Double = dic["Latitude"] as! Double
                    let longitude:Double = dic["Longitude"] as! Double
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let location1 = CLLocation(latitude: myLatitude, longitude: myLongitude)
                    print("-----------------------------------")
                    print("Location: ", latitude , longitude)
                    print("My Location: ", myLatitude , myLongitude)
                    print("-----------------------------------")
                    if self.locationIsInRange(myLocation: location, surveyLocation: location1){
                        print("There is a fight in your location")
                        if self.battlesArr?.append(dic) == nil {
                            self.battlesArr = [dic]
                        }
                        self.idArr.append(snapshot.key)
                    }
                    else {
                        print("There is no fight in your location")
                    }
                }
            }
                self.displayBattle()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayBattle() {
        if let arr = battlesArr {
            let len = arr.count
            if len != 0 {
                errorLabel.isHidden = true
                randomIndex = Int(arc4random_uniform(UInt32(len)))
                
                let dict = arr[randomIndex]
                self.contender1Label.text = dict["Contender 1"]!["Name"] as? String
                let votes1 = dict["Contender 1"]!["Votes"] as! Int
                self.percentage1Label.text = String(votes1)
                
                self.contender2Label.text = dict["Contender 2"]!["Name"] as? String
                let votes2 = dict["Contender 2"]!["Votes"] as! Int
                self.percentage2Label.text = String(votes2)
                
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

    
    
    
    func locationIsInRange(myLocation: CLLocation, surveyLocation: CLLocation) -> Bool {
    if myLocation.distance(from: surveyLocation) < locationRadius*1000 {
        print("Success Location distance is: ", myLocation.distance(from: surveyLocation))
        return true
        }
        print("Failed Location distance is: ", myLocation.distance(from: surveyLocation))
        return false
    }
    
}


