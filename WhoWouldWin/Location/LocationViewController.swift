//
//  LocationViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 10.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate  {

    let manager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sliderMap: UISlider!
    @IBOutlet weak var submitButton: UIButton!
    var selectedDistance:Int = 50
    

    
    
    @IBAction func submitButton(_ sender: Any) {
        
    }
    
    @IBAction func sliderMap(_ sender: UISlider) {
        selectedDistance = Int(sender.value)
        
        let buttonText:String = "Radius: " + selectedDistance.description + " km"
        
        submitButton.setTitle(buttonText, for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitle("Radius: " + selectedDistance.description + " km", for: .normal)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLoction:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLoction, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
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
