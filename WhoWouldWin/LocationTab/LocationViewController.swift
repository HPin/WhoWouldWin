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

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    let manager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sliderMap: UISlider!
    @IBOutlet weak var submitButton: UIButton!
    var selectedDistance:Int = 50
    
    
    @IBAction func submitButton(_ sender: Any) {
        performSegue(withIdentifier: "locationSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! LocationBattleViewController
        secondViewController.locationRadius = Double(selectedDistance)
        let backItem = UIBarButtonItem()
        backItem.title = "Change Radius"
        navigationItem.backBarButtonItem = backItem
    }
    
    
    @IBAction func sliderMap(_ sender: UISlider) {
        selectedDistance = Int(sender.value)
        
        let buttonText:String = "Search Radius: " + selectedDistance.description + " km"
        
        submitButton.setTitle(buttonText, for: .normal)
        showCircle(coordinate: (manager.location?.coordinate)!, radius: Double(selectedDistance), mapView: mapView)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitle("Search Radius: " + selectedDistance.description + " km", for: .normal)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        showCircle(coordinate: (manager.location?.coordinate)!, radius: Double(selectedDistance), mapView: mapView)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(3, 3)
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
    
    private func mapView(_ mapView: MKMapView, rendererFor overlay: MKCircle) -> MKOverlayRenderer {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, mapView: MKMapView) {
        self.mapView.delegate = self
        let circle = MKCircle(center: coordinate, radius: radius)
        mapView.add(circle)
    }
  

}
