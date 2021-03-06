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

class LocationBattleViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var noBattlesLeftView: UIView!
    @IBOutlet weak var noBattlesLeftImageView: UIImageView!
    
    @IBOutlet weak var centerCircleView: UIView!
    @IBOutlet weak var centerCircleImageView: UIImageView!
    
    @IBOutlet weak var battleCollectionView: UICollectionView!
    
    var ref: DatabaseReference?
    var loc: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    let manager = CLLocationManager()
    var locationRadius:Double = 50
    
    var idArr = [String]()
    var battlesArr:[[String:AnyObject]]?
    var randomIndex: Int = 0
    
    var nameContender1: String = ""
    var nameContender2: String = ""
    var votesContender1: Double = 0
    var votesContender2: Double = 0
    var imageURLContender1: String?
    var imageURLContender2: String?
    
    var categoryName: String!
    
    var hasVotedFor1: Bool = false
    var hasVotedFor2: Bool = false
    var areBattlesLeft: Bool = true
    
    // ------------------- overlay delegate stuff -------------------
    
    @IBOutlet weak var overlaySubview: UIView!
    
    
    // pass reference to self into overlay, otherwise we encounter a nil object there
    lazy var addOverlay: LocationViewController = {
        let overlay = LocationViewController()
        overlay.locationBattleVC = self
        return overlay
    }()
    
    func dismissTheOverlay() {
        addOverlay.dismissOverlay()
    }
    
    func getRadius(radius: Int) {
        self.locationRadius = Double(radius)
//        getData { (display) in
//            if display {
//                self.displayBattle()
//            }
//        }
    }
    
    @IBAction func showOverlayButton(_ sender: UIBarButtonItem) {
        addOverlay.createOverlay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showOverlaySegue" {
            if let sender = segue.destination as? LocationViewController {
                sender.delegate = self
            }
        }
    }
// -------------------END: overlay delegate stuff -------------------

    override func viewDidLayoutSubviews() {
        centerCircleView.layer.cornerRadius = centerCircleView.frame.width / 2
        centerCircleView.layer.borderWidth = 4
        let myColor : UIColor = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        centerCircleView.layer.backgroundColor = myColor.cgColor
        centerCircleView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        battleCollectionView?.reloadData()
    }

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlaySubview.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 300)
        
        let randNothingLeftIndex = Int(arc4random_uniform(UInt32(10))) + 1
        noBattlesLeftImageView.loadGif(name: "nothingLeft\(randNothingLeftIndex)")
        
        getData { (display) in
            if display {
                self.displayBattle()
            }
        }
        
        //----- collection view stuff:----------------
        let screenHeight = UIScreen.main.bounds.height
        let tabBarHeight: CGFloat = 49
        let navBarHeight: CGFloat = 64
        let cvHeight = screenHeight - tabBarHeight - navBarHeight
        let fullSpacing: CGFloat = 6
        let halfSpacing: CGFloat = fullSpacing / 2
        
        let itemHeight = cvHeight / 2 - halfSpacing
        let itemWidth = UIScreen.main.bounds.width
        
        let customLayout = UICollectionViewFlowLayout()
        customLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        customLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        //customLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        
        customLayout.minimumLineSpacing = fullSpacing
        
        battleCollectionView.collectionViewLayout = customLayout
        
        battleCollectionView?.reloadData()

    }
    
    func getData(completion: @escaping (Bool) -> Void){
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.startUpdatingLocation()
        guard let myLocation:CLLocation = manager.location else {
            let alert = UIAlertController(title: "Could not get location!", message: "Make sure to enable location services.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let myLatitude = myLocation.coordinate.latitude
        let myLongitude = myLocation.coordinate.longitude
        var display = true
        
//        self.ref?.child("Users").observeSingleEvent(of: .value, with: { snapshot in
        
        ref = Database.database().reference()
        ref?.child("Locations").observeSingleEvent(of: .value, with: { snapshot in
            //print(snapshot)
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if let dic = rest.value as? [String:AnyObject] {
                    print(dic)
                    let latitude:Double = dic["Latitude"] as! Double
                    let longitude:Double = dic["Longitude"] as! Double
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let location1 = CLLocation(latitude: myLatitude, longitude: myLongitude)
                    print("-----------------------------------")
                    print("Location: ", latitude , longitude)
                    print("My Location: ", myLatitude , myLongitude)
                    print("-----------------------------------")
                    if self.locationIsInRange(myLocation: location, surveyLocation: location1){
                        print("There is a fight in your location")
                        if self.battlesArr?.append(dic) == nil {
                            self.battlesArr = [dic]
                        }
                        self.idArr.append(rest.key)
                        self.noBattlesLeftView.isHidden = true
                    }
                    else {
                        print("There is no fight in your location")
                        if let arr = self.battlesArr {
                            if arr.isEmpty {
                                //display = false
                                self.noBattlesLeftView.isHidden = false
                            } else {
                                //display = true
                                self.noBattlesLeftView.isHidden = true
                            }
                        } else {
                            //display = false
                            self.noBattlesLeftView.isHidden = false
                        }
                    }

                }
            }
            completion(display)
        })
    }
    
    func displayBattle() {
        if areBattlesLeft {
            noBattlesLeftView.isHidden = true
        } else {
            noBattlesLeftView.isHidden = false
        }
        
        if let arr = battlesArr {
            let len = arr.count
            if len != 0 {
                
                //errorLabel.isHidden = true
                randomIndex = Int(arc4random_uniform(UInt32(len)))
                
                let dict = arr[randomIndex]
                
                if let cat = dict["Category"] as? String {
                    switch cat {
                    case "Beauty Contest":
                        centerCircleImageView.image = UIImage(named: "cellBeauty2 Contest")
                    case "Fight":
                        centerCircleImageView.image = UIImage(named: "cellFight2")
                    case "Rap Battle":
                        centerCircleImageView.image = UIImage(named: "cellRap5 Battle")
                    case "Dance Battle":
                        centerCircleImageView.image = UIImage(named: "cellDance Battle")
                    default:
                        centerCircleImageView.image = UIImage(named: "cellFight")
                    }
                    self.navigationItem.title = cat
                }
                
                if let name1 = dict["Contender 1"]?["Name"] as? String {
                    nameContender1 = name1
                }
                if let votes1 = dict["Contender 1"]?["Votes"] as? Double {
                    votesContender1 = votes1
                }
                if let imgURL1 = dict["Contender 1"]?["Image"] as? String {
                    imageURLContender1 = imgURL1
                }
                
                if let name2 = dict["Contender 2"]?["Name"] as? String {
                    nameContender2 = name2
                }
                if let votes2 = dict["Contender 2"]?["Votes"] as? Double {
                    votesContender2 = votes2
                }
                if let imgURL2 = dict["Contender 2"]?["Image"] as? String {
                    imageURLContender2 = imgURL2
                }
                
                battleCollectionView?.reloadData()
            } else {
                //                vote1Button.isHidden = true
                //                vote2Button.isHidden = true
                //                nextButton.isHidden = true
                //                errorLabel.isHidden = false
            }
            
        }
    }

    
    
    
    func locationIsInRange(myLocation: CLLocation, surveyLocation: CLLocation) -> Bool {
    if myLocation.distance(from: surveyLocation) < locationRadius*1000 {
        print("Success Location distance is: ", myLocation.distance(from: surveyLocation))
        return true
        }
        print("Failed Location distance is: ", myLocation.distance(from: surveyLocation))
        return false
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as! LocationVCCollectionViewCell
        
        var name = "empty"
        //cell.contenderImageView.image = UIImage(named: "fight.jpg")   // provide a default image
        
        if indexPath.row == 0 {
            
            name = nameContender1
            
            if let imgURLString = imageURLContender1 {
                let url = URL(string: imgURLString)
                
                cell.contenderImageView.sd_setImage(with: url)
            }
        }
        if indexPath.row == 1 {
            name = nameContender2
            
            if let imgURLString = imageURLContender2 {
                let url = URL(string: imgURLString)
                
                cell.contenderImageView.sd_setShowActivityIndicatorView(true)
                cell.contenderImageView.sd_setIndicatorStyle(.gray)
                cell.contenderImageView.sd_setImage(with: url)
            }
        }
        
        let textAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -1,
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 40)
            ] as [NSAttributedStringKey : Any]
        
        cell.nameLabel.attributedText = NSAttributedString(string: name, attributes: textAttributes)
        
        
        if hasVotedFor1 {
            if indexPath.row == 0 {
                cell.colorOverlay.backgroundColor = UIColor.green
            }
            if indexPath.row == 1 {
                cell.colorOverlay.backgroundColor = UIColor.red
            }
        } else if hasVotedFor2 {
            if indexPath.row == 0 {
                cell.colorOverlay.backgroundColor = UIColor.red
            }
            if indexPath.row == 1 {
                cell.colorOverlay.backgroundColor = UIColor.green
            }
        }
        
        if hasVotedFor1 || hasVotedFor2 {
            
            let textAttributes = [
                NSAttributedStringKey.strokeColor : UIColor.black,
                NSAttributedStringKey.foregroundColor : UIColor.green,
                NSAttributedStringKey.strokeWidth : -1,
                NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 50)
                ] as [NSAttributedStringKey : Any]
            
            let percent1 = calcPercent()
            if indexPath.row == 0 {
                let text = String(percent1) + " %"
                cell.percentLabel.attributedText = NSAttributedString(string: text, attributes: textAttributes)
            }
            if indexPath.row == 1 {
                let text = String(100 - percent1)  + " %"
                cell.percentLabel.attributedText = NSAttributedString(string: text, attributes: textAttributes)
            }
            cell.percentLabel.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                cell.percentLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                if indexPath.row == 0 {
                    cell.nameLabel.transform = CGAffineTransform(translationX: 0, y: -40)
                    cell.percentLabel.transform = CGAffineTransform(translationX: 0, y: 40)
                } else {
                    cell.nameLabel.transform = CGAffineTransform(translationX: 0, y: 40)
                    cell.percentLabel.transform = CGAffineTransform(translationX: 0, y: -40)
                }
            })
        } else {
            // reset cell
            cell.nameLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.percentLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            cell.percentLabel.isHidden = true
            cell.colorOverlay.backgroundColor = UIColor.black
        }
        
        return cell
    }
    
    func calcPercent() -> Double {
        // catch corner cases (div 0 errors)
        if votesContender1 == votesContender2 {
            return 50
        }
        if votesContender1 != 0 && votesContender2 == 0 {
            return 100
        }
        if votesContender1 == 0 && votesContender2 != 0 {
            return 0
        }
        
        // regular case: return percent of c1...(votes/totalvotes*100)
        let percent = votesContender1 / (votesContender1 + votesContender2) * 100
        let rounded = round(10 * percent) / 10
        return rounded
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            votesContender1 += 1
            
            let ID = idArr[randomIndex]
            let battleRef = ref?.child("Locations").child(ID)
            
            battleRef?.child("Contender 1").child("Votes").setValue(votesContender1)
            
            hasVotedFor1 = true
            hasVotedFor2 = false
            
            battleCollectionView?.reloadData()
            loadNextBattle()
            
        }
        if indexPath.row == 1 {
            votesContender2 += 1
            
            let ID = idArr[randomIndex]
            let battleRef = ref?.child("Locations").child(ID)
            
            battleRef?.child("Contender 2").child("Votes").setValue(votesContender2)
            
            hasVotedFor2 = true
            hasVotedFor1 = false
            
            battleCollectionView?.reloadData()
            loadNextBattle()
        }
    }
    
    
    
    
    func loadNextBattle() {
        
        UIView.animate(withDuration: 0.3, delay: 3.5, options: .curveEaseIn, animations: {
            self.battleCollectionView.transform = CGAffineTransform(translationX: -800, y: 0)
            self.centerCircleView.transform = CGAffineTransform(translationX: -800, y:0)
        }, completion: { (finished) in
            self.hasVotedFor1 = false
            self.hasVotedFor2 = false
            
            if let arr = self.battlesArr {
                if arr.count > 1 {
                    self.areBattlesLeft = true
                    self.battlesArr?.remove(at: self.randomIndex)
                    self.idArr.remove(at: self.randomIndex)
                } else {
                    self.areBattlesLeft = false
                    print("no battles left")
                }
            }
            self.displayBattle()
            
            self.battleCollectionView.transform = CGAffineTransform(translationX: 800, y: 0)
            self.centerCircleView.transform = CGAffineTransform(translationX: 800, y:0)
            UIView.animate(withDuration: 0.25, animations: {
                self.battleCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.centerCircleView.transform = CGAffineTransform(translationX: 0, y:0)
            })
        })
        
    }
    
}


