//
//  LoginViewController.swift
//  WhoWouldWin
//
//  Created by HP on 04.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    
    @IBAction func signInButton(_ sender: CustomButton) {
        var errorMessage = ""

        if eMailTextField.text == "" || passwordTextField.text == ""{
            if eMailTextField.text == "" {
                errorMessage.append("E-Mail ")
            }
            if passwordTextField.text == ""{
                errorMessage.append("Password ")
            }
            passwordTextField.text = ""
            eMailTextField.text = ""
            var alertMessage = "Following fields have to be filled in properly: "
            alertMessage.append(errorMessage)
            let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }

        else {
            Auth.auth().signIn(withEmail: eMailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if user != nil {
                    //sign in successfull
                    self.performSegue(withIdentifier: "fromLoginToStart", sender: self)
                }
                else {
                    //there is an error
                    guard let myError = error?.localizedDescription else {
                        self.passwordTextField.text = ""
                        self.eMailTextField.text = ""
                        let alert = UIAlertController(title: "Error", message: "Try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    self.passwordTextField.text = ""
                    self.eMailTextField.text = ""
                    let alert = UIAlertController(title: "Error", message: myError, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })

        }
//        self.performSegue(withIdentifier: "fromLoginToStart", sender: self)
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
