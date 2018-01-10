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
    var refHandle: DatabaseHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self
        //100 meters is the accurayc: possible changes -> 10m or bestpossible
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    
    //checks in 10km radius
    func locationIsInRange(myLocation: CLLocation, surveyLocation: CLLocation) -> Bool {
    if myLocation.distance(from: surveyLocation) < 10000 {
        return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


