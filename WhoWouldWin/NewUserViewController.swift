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
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: CustomButton) {
        var nickName = ""
        var eMail = ""
        var password = ""
        
        var isNameValid = false
        var isEMailValid = false
        var isPasswordValid = false
        
        if nameTextField.text != nil {
            // check if name is valid
            nickName = nameTextField.text!
            
            isNameValid = true
        } else {
            // throw alert
        }
        
        if eMailTextField.text != nil {
            // check if mail is valid
            eMail = eMailTextField.text!
            
            isEMailValid = true
        } else {
            // throw alert
        }
        
        if passwordTextField.text != nil {
            // check if pw is valid
            password = passwordTextField.text!
            
            if password.count < 6 {
                // throw alert if pw too short
            } else {
                isPasswordValid = true
            }
        } else {
            // throw alert
        }
        
        
        // store new user account in firebase:
        if isPasswordValid && isEMailValid && isNameValid {

            Auth.auth().createUser(withEmail: eMail, password: password) { (user, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                print("user successfully authenticated")
            }
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
