//
//  StoreNewBattleViewController.swift
//  WhoWouldWin
//
//  Created by HP on 26.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseStorage

class StoreNewBattleViewController: UIViewController, CLLocationManagerDelegate {

    // data passed from previous VCs:
    var categoryClicked: String?
    var isGlobalBattle: Bool?
    var name1: String?
    var name2: String?
    var image1: UIImage?
    var image2: UIImage?
    
    // data for database storage:
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    let manager = CLLocationManager()
    var battleCount: UInt = 0
    var globalOrLocation: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        storeInDatabase()
    }
    
    func storeInDatabase() {
        guard let isGlobal = isGlobalBattle else {
            print("isglobal nil")
            return
        }
        guard let category = categoryClicked else {
            print("cat nil")
            return
        }
        guard let nameC1 = name1 else {
            print("n1 nil")
            return
        }
        guard let nameC2 = name2 else {
            print("n2 nil")
            return
        }
        guard let img1 = image1 else {
            print("i1 nil")
            return
        }
        guard let img2 = image2 else {
            print("i2 nil")
            return
        }

        print(isGlobal)
        print(category)
        print("c1" + nameC1)
        print("c2" + nameC2)
        
        if isGlobal {

            let battleRef = ref?.child("Categories").child(category).childByAutoId()

            if let img1Data = UIImagePNGRepresentation(img1) {

                let randomID = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child(randomID + ".png")
                let uploadTask = storageRef.putData(img1Data, metadata: nil, completion: { (metadata, error) in

                    guard let metadata = metadata else {
                        print("----An error occurred!")
                        return
                    }
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let imgURL = metadata.downloadURL()?.absoluteString

                    battleRef?.child("Contender 1").setValue(["Name": nameC1, "Votes" : 0, "Image": imgURL])
                })
            }

            if let img2Data = UIImagePNGRepresentation(img2) {

                let randomID = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child(randomID + ".png")
                let uploadTask = storageRef.putData(img2Data, metadata: nil, completion: { (metadata, error) in

                    guard let metadata = metadata else {
                        print("----An error occurred!")
                        return
                    }
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let imgURL = metadata.downloadURL()?.absoluteString

                    battleRef?.child("Contender 2").setValue(["Name": nameC2, "Votes" : 0, "Image": imgURL])
                })
            }

        } else {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            guard let latitude:Double = manager.location?.coordinate.latitude else {return}
            guard let longitude:Double = manager.location?.coordinate.longitude else {return}

            //write in the actual data
            let battleRef = ref?.child("Locations").childByAutoId()
            battleRef?.setValue(["Latitude": latitude, "Longitude": longitude, "Category": category])
            battleRef?.child("Contender 1").setValue(["Name": nameC1, "Votes": 0])
            battleRef?.child("Contender 2").setValue(["Name": nameC2, "Votes": 0])
        }
    }
}