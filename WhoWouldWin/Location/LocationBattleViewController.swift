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
        
        refHandle = ref?.child("Locations").observe(.value, with: { (snapshot) in
            for location in snapshot.children{
                print(location)
            }
        })
        
        //let childSnapshot = snapshot.childSnapshotForPath(child.key)
        
        
//        let databaseHandle = databaseRef.observe(.value, with: { (snapshot) in
//            for item in snapshot.children {
//
//                if let dbLocation = snapshot.childSnapshot(forPath: "LocationName") as? String {
//
//                    print (dbLocation)
//                }
//
//                print(item)
//
//            }


    }

    
    
    //checks the radius
    func locationIsInRange(myLocation: CLLocation, surveyLocation: CLLocation) -> Bool {
    if myLocation.distance(from: surveyLocation) < locationRadius {
        return true
        }
        return false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


