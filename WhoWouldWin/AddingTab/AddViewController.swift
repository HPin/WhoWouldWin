//
//  AddViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 11.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var categories = [String]()
    var categoryClicked: String = "Fight"   // default: First picker entry
    var battleCount: UInt = 0
    
    @IBOutlet weak var locationSegControl: UISegmentedControl!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var name1Label: UITextField!
    @IBOutlet weak var name2Label: UITextField!
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        let battleNo = categoryClicked + " " + String(battleCount)
        
        let battleRef = ref?.child("Categories").child(categoryClicked).child(battleNo)
        
        battleRef?.child("Contender 1").setValue(["Name": "Jakob", "Votes" : 0])
        battleRef?.child("Contender 2").setValue(["Name": "Toaster", "Votes" : 0])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        refHandle = ref?.child("Categories").observe(.childAdded, with: { (snapshot) in
            
            let post = snapshot.key
            self.categories.append(post)
            self.categoryPicker.reloadAllComponents()
        })
        
        ref?.child("Categories").child(categoryClicked).observeSingleEvent(of: .value, with: { (snapshot) in
            self.battleCount = snapshot.childrenCount
        })
       
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowTitle = categories[row]
        let attributedTitle = NSAttributedString(string: rowTitle, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
        return attributedTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryClicked = categories[row]
    }

}
