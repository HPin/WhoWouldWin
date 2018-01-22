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
        
        var isNameValid = false
        var isEMailValid = false
        var isPasswordValid = false
        var isPasswordConfValid = false
        
        
        if nameTextField.text != "" {
            nickName = nameTextField.text!
            isNameValid = true
        }
        
        if eMailTextField.text != "" {
            myEmail = eMailTextField.text!
            
            isEMailValid = true
        }
        
        if passwordTextField.text != "" {
            password = passwordTextField.text!
            if password.count >= 6 {
                isPasswordValid = true
            }
        }
        
        if passwordConfirmTextField.text != "" {
            isPasswordConfValid = true
        }
        
        
        if isNameValid != true || isEMailValid != true || isPasswordValid != true || isPasswordConfValid != true{
            var alertMessage = ""
            if isNameValid != true {
                alertMessage.append("Nickname ")
            }
            if isEMailValid != true {
                alertMessage.append("| E-Mail ")
            }
            if isPasswordValid != true {
                alertMessage.append("| Password ")
            }
            if isPasswordConfValid != true {
                alertMessage.append("| Password Conformation")
            }
            
            nameTextField.text = ""
            eMailTextField.text = ""
            passwordTextField.text = ""
            passwordConfirmTextField.text = ""
            
            var errorMessage = "Following field(s) has/have to be filled in correctly (password size at least 6): "
            errorMessage.append(alertMessage)
            
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if passwordTextField.text != passwordConfirmTextField.text{
            
            passwordTextField.text = ""
            passwordConfirmTextField.text = ""
            let alert = UIAlertController(title: "Error", message: "Password and Password Conformation have to be exectly the same input!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else{
            
            firebaseCheckDatabase(nickName: nickName, myEmail: myEmail, password: password) { (success, nameExists, mailExists) in
                if success {
                    self.authentificateUser(nickName: nickName, myEmail: myEmail, password: password)
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "fromLoginToStart", sender: LoginViewController.self)
                } else{
                    var errorMessage = ""
                    if nameExists {
                        self.nameTextField.text = ""
                        errorMessage.append("Nickname ")
                    }
                    if mailExists {
                        self.eMailTextField.text = ""
                        errorMessage.append("E-Mail ")
                    }
                    errorMessage.append("is/are already in use!")
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func authentificateUser(nickName: String, myEmail: String, password: String){
        // store new user account in firebase:
        
        Auth.auth().createUser(withEmail: myEmail, password: password) { (user, error) in
                if error != nil {
                    print("Error in Authentication: ", error)
                    return
                }
                print("user successfully authenticated")
                
                //store USER into DATABASE
                let userDB = self.ref?.child("Users").childByAutoId()
                userDB?.setValue(["name": nickName, "email" : myEmail, "uid": user?.uid])
        }
    }
    
    
    func firebaseCheckDatabase(nickName: String, myEmail: String, password: String, completion: @escaping (Bool, Bool, Bool) -> Void){
        //check if User already exists
        var checkDB = true
        var nameExists = false
        var mailExists = false
        self.ref = Database.database().reference()
        
        self.ref?.child("Users").observeSingleEvent(of: .value, with: { snapshot in
            print("Children ")
            print(snapshot.childrenCount)
            print("+++++++++")
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if let dic = rest.value as? [String:AnyObject]{
                    if dic["name"] as? String == nickName {
                        checkDB = false
                        nameExists = true
                    }
                    let email = dic["email"] as? String
                    if email?.lowercased() == myEmail.lowercased() {
                        checkDB = false
                        mailExists = true
                    }
                }
            }
            completion(checkDB, nameExists, mailExists)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
