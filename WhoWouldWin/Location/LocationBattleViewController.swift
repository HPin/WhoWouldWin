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
            if let dic = snapshot.value as? [String:AnyObject] {
                print(dic)
                let latitude:Double = dic["Latitude"] as! Double
                let longitude:Double = dic["Longitude"] as! Double
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let location1 = CLLocation(latitude: myLatitude, longitude: myLongitude)
                if self.locationIsInRange(myLocation: location, surveyLocation: location1){
                    //there is a Battle with the same location!
                    
                }
                
            }
        })
        

    }

    
    
    //checks the radius
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


