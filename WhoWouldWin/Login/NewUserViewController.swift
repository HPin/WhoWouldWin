//
//  NewUserViewController.swift
//  WhoWouldWin
//
//  Created by HP on 04.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import Firebase

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: CustomButton) {
        var nickName = ""
        var myEmail = ""
        var password = ""
        var errorAlertMessage = ""
        
        var isNameValid = false
        var isEMailValid = false
        
        
        if nameTextField.text != nil {
            nickName = nameTextField.text!
            
            isNameValid = true
        } else {
            errorAlertMessage.append("Nickname")
        }
        
        if eMailTextField.text != nil {
            myEmail = eMailTextField.text!
            
            isEMailValid = true
        } else {
            errorAlertMessage.append(",E-Mail")
        }
        
        if passwordTextField.text != nil {
            password = passwordTextField.text!
            
            if password.count < 6 {
                // throw alert if pw too short
                return
            }
        }
        
        if isNameValid != true || isEMailValid != true {
            //alert with errorAlertMessage
            
            
            return
        }
        
        
        print("--------------------")
        print("---FIREBASE CHECK---")
        print("--------------------")
        //check if User already exists
        ref = Database.database().reference()
        
        refHandle = ref?.child("Users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dic = snapshot.value as? [String:AnyObject] {
                let name = dic["name"] as! String
                if name == nickName {
                    print("This nickname already exists!")
                    return
                }
                let email = dic["email"] as! String
                if email == myEmail {
                    print("This E-Mail already exists!")
                    return
                }
            }
        })
        
        print("--------------------")
        print("--AUTHENTIFICATION--")
        print("--------------------")
        // store new user account in firebase:
        Auth.auth().createUser(withEmail: myEmail, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
                }
            print("user successfully authenticated")
            print("#######################")
            print("#######################")
            print(user?.displayName)
            print("#######################")
            print("#######################")
            
            //store USER into DATABASE
            let userDB = self.ref?.child("Users").childByAutoId()
            userDB?.setValue(["name": nickName, "email" : myEmail, "uid": user?.uid])
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
