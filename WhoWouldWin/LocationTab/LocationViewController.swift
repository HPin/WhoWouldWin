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

protocol LocationTabOverlayDelegate: class {
    func dismissTheOverlay()
    func getRadius(radius: Int)
}
class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    weak var delegate: LocationBattleViewController?
    let blackView = UIView()
    var locationBattleVC: LocationBattleViewController?

    let manager = CLLocationManager()
    
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    
    var selectedDistance:Int = 50
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let secondViewController = segue.destination as! LocationBattleViewController
//        secondViewController.locationRadius = Double(selectedDistance)
//        let backItem = UIBarButtonItem()
//        backItem.title = "Change Radius"
//        navigationItem.backBarButtonItem = backItem
//    }
    

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        delegate?.dismissTheOverlay()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        delegate?.dismissTheOverlay()
        delegate?.getRadius(radius: self.selectedDistance)
    }
    
    func createOverlay() {
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissOverlay)))
        
        
        //window.addSubview(blackView)
        //window.addSubview((addCourseViewController?.overlaySubview)!)
        
        locationBattleVC?.view.addSubview(blackView)
        
        // add overlay after(!) black view
        locationBattleVC?.view.addSubview((locationBattleVC?.overlaySubview)!)
        
        blackView.frame = view.frame
        blackView.alpha = 0                 // set alpha to 0 for animation
        
        
        let overlayHeight: CGFloat = 300
        //overlaySubview.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 300)
        
        UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            
            let overlayYLocation = self.view.frame.height - overlayHeight
            self.locationBattleVC?.overlaySubview.frame = CGRect(x: 0, y: overlayYLocation, width: self.view.frame.width, height: overlayHeight)
            
        }, completion: nil)
    }
    
    @objc func dismissOverlay() {
        
        //self.blackView.backgroundColor = UIColor.blue
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            self.locationBattleVC?.overlaySubview.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300)
            
        }) { (completed: Bool) in
            self.blackView.removeFromSuperview()
            
        }
    }
    
    
    @IBAction func radiusSlider(_ sender: UISlider) {
        selectedDistance = Int(sender.value)
        
        let text: String = "Radius: " + selectedDistance.description + " km"
        radiusLabel.text = text
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let text: String = "Radius: \(selectedDistance) km"
//        radiusLabel.text = text
        
        manager.delegate = self
        
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(3, 3)
        let myLoction:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLoction, span)
//        mapView.setRegion(region, animated: true)
//        self.mapView.showsUserLocation = true
        
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
