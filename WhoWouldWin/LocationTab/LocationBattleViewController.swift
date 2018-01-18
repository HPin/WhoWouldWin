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
    
    let manager = CLLocationManager()
    var ref: DatabaseReference?
    var loc: DatabaseReference?
    var refHandle: DatabaseHandle?
    var locationRadius:Double = 10
    var idArr = [String]()
    var battlesArr:[[String:AnyObject]]?
    var randomIndex: Int = 0
    
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
        
        ref?.child("Locations").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dic = snapshot.value as? [String:AnyObject] {
                print("----------")
                print(dic)
                let latitude:Double = dic["Latitude"] as! Double
                let longitude:Double = dic["Longitude"] as! Double
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let location1 = CLLocation(latitude: myLatitude, longitude: myLongitude)
                if self.locationIsInRange(myLocation: location, surveyLocation: location1){
                    //there is a Battle with the location range
                    if self.battlesArr?.append(dic) == nil {
                        self.battlesArr = [dic]
                    }
                    self.idArr.append(snapshot.key)
                }
            }
        })
    }
    
    func displayBattle() {
        if let arr = battlesArr {
            let len = arr.count
            if len != 0 {
                //errorLabel.isHidden = true
                randomIndex = Int(arc4random_uniform(UInt32(len)))
                
                let dict = arr[randomIndex]
                //self.contender1Label.text = dict["Contender 1"]!["Name"] as? String
                let votes1 = dict["Contender 1"]!["Votes"] as! Int
                //self.percent1Label.text = String(votes1)
                
                //self.contender2Label.text = dict["Contender 2"]!["Name"] as? String
                let votes2 = dict["Contender 2"]!["Votes"] as! Int
                //self.percent2Label.text = String(votes2)
                
//                votesContender1 = votes1
//                votesContender2 = votes2
            } else {
//                vote1Button.isHidden = true
//                vote2Button.isHidden = true
//                nextButton.isHidden = true
//                errorLabel.isHidden = false
                
            }
            
        }
    }

    
    
    
    func locationIsInRange(myLocation: CLLocation, surveyLocation: CLLocation) -> Bool {
    if myLocation.distance(from: surveyLocation) < locationRadius*1000 {
        return true
        }
        return false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


