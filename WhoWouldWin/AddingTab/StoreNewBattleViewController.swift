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
    
    func storeBattlesInUser(uid: String, keyString: String) {
        ref = Database.database().reference()
        ref?.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot{
                if let dic = rest.value as? [String:AnyObject]{
                    if dic["uid"] as? String == uid{
                        let myRef = rest.ref
                        myRef.child("battles").childByAutoId().setValue(keyString)
                    }
                }
            }
        }
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
            print("getting in isglobal ------------------")

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
            guard let myUID = Auth.auth().currentUser?.uid else {return}
            guard let myKeyString = battleRef?.key else {return}
            storeBattlesInUser(uid: myUID, keyString: myKeyString)
            
            battleRef?.child("user").setValue(myUID)
            

        } else {
            print("getting in not global------------------")

            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            guard let latitude:Double = manager.location?.coordinate.latitude else {return}
            guard let longitude:Double = manager.location?.coordinate.longitude else {return}
            print("getting in ------------------")
            //write in the actual data
            let battleRef = ref?.child("Locations").childByAutoId()
            battleRef?.setValue(["Latitude": latitude, "Longitude": longitude, "Category": category])
//            battleRef?.child("Contender 1").setValue(["Name": nameC1, "Votes": 0])
//            battleRef?.child("Contender 2").setValue(["Name": nameC2, "Votes": 0])
            
            guard let myUID = Auth.auth().currentUser?.uid else {return}
            guard let myKeyString = battleRef?.key else {return}
            storeBattlesInUser(uid: myUID, keyString: myKeyString)
            
            battleRef?.child("user").setValue(myUID)
            
            // add images ---------
            if let img1Data = UIImagePNGRepresentation(img1) {
                print("img1 in ------------------")

                let randomID = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child(randomID + ".png")
                let uploadTask = storageRef.putData(img1Data, metadata: nil, completion: { (metadata, error) in
                    print("uploading in ------------------")

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
        }
    }
}
