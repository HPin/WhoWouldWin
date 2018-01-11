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
        
        ref = Database.database().reference()
        
        ref?.child("Locations").observe(.childAdded, with: { (snapshot) in
            if let dic = snapshot.value as? [String:AnyObject] {
                print(dic)
                let latitude:Double = dic["Latitude"] as! Double
                let longitude:Double = dic["Longitude"] as! Double
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let location1 = CLLocation(latitude: 50.785834, longitude: -122.406417)
                if self.locationIsInRange(myLocation: location, surveyLocation: location1){
                    print("LECK MEINE EIER ES FUNKTIONIERT FICKEN!!!!")
                    print("LECK MEINE EIER ES FUNKTIONIERT FICKEN!!!!")
                    print("LECK MEINE EIER ES FUNKTIONIERT FICKEN!!!!")
                    print("LECK MEINE EIER ES FUNKTIONIERT FICKEN!!!!")
                    print("LECK MEINE EIER ES FUNKTIONIERT FICKEN!!!!")
                    print("LECK MEINE EIER ES FUNKTIONIERT FICKEN!!!!")
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


