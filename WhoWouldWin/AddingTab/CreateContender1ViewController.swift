//
//  AddNewBattleViewController.swift
//  WhoWouldWin
//
//  Created by HP on 26.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit

class CreateContender1ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var categoryClicked: String?
    var isGlobalBattle: Bool?
    var name1: String = ""
    var image1: UIImage?
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var camRollButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            //self.topLabel.transform = CGAffineTransform(translationX: 0, y: -150)
            self.instructionLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            self.continueButton.transform = CGAffineTransform(translationX: 0, y: 60)
            
            // animations when returning from image picker:
            self.imageView.transform = CGAffineTransform(translationX: 0, y: 70)
            self.saveButton.transform = CGAffineTransform(translationX: 0, y: 200)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // first view
        topLabel.isHidden = false
        instructionLabel.isHidden = false
        nameTextField.isHidden = false
        continueButton.isHidden = false
        
        // second view
        camRollButton.isHidden = true
        saveButton.isHidden = true
        imageView.isHidden = true
        
        // reset location of ui elements
        //self.topLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        self.instructionLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        self.nameTextField.transform = CGAffineTransform(translationX: 0, y: 0)
        self.continueButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.camRollButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.saveButton.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueButton(_ sender: UIButton) {
        // save text field input
        // error msg if no input
        
        UIView.animate(withDuration: 0.25, animations: {
            // remove name input items from screen
            self.nameTextField.transform = CGAffineTransform(translationX: 500, y: 0)
            self.continueButton.transform = CGAffineTransform(translationX: 0, y: 800)
        }) { (finished) in
            self.nameTextField.isHidden = true
            self.continueButton.isHidden = true
            self.buttonFlyIn()
        }
    }
    
    func buttonFlyIn() {
        instructionLabel.text = "Now, select an image."
        camRollButton.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.camRollButton.transform = CGAffineTransform(translationX: 0, y: 30)
        }) { (finished) in
            
        }
    }
    
    @IBAction func camRollButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true) {
            // this code gets executed once the picker gets closed
            self.nameTextField.isHidden = true
            self.continueButton.isHidden = true
            self.camRollButton.isHidden = true
            self.imageView.isHidden = false
            self.saveButton.isHidden = false
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = editedImage
            self.image1 = editedImage
        } else if let origImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = origImage
            self.image1 = origImage
        } else {
            print("error when selecting image")
        }
        
        self.dismiss(animated: true, completion: nil)   // close picker
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if let name = nameTextField.text {
            name1 = name
        } else {
            name1 = ""
        }
        
        performSegue(withIdentifier: "createCont2Segue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createCont2Segue" {
            if let destVC = segue.destination as? CreateContender2ViewController {
                
                destVC.categoryClicked = self.categoryClicked
                destVC.isGlobalBattle = self.isGlobalBattle
                destVC.name1 = self.name1
                destVC.image1 = self.image1
            }
        }
    }
    

}
