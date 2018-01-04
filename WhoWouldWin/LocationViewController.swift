//
//  LocationViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 04.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

   let manager = CLLocationManager()
    
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self
        //100 meters is the accurayc: possible changes -> 10m or bestpossible
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
