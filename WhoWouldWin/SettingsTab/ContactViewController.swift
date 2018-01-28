//
//  ContactViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 28.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var contactImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = UIImage(named: "ContactTab")
        contactImageView?.image = imageName
        contactImageView.layer.cornerRadius = 20
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
