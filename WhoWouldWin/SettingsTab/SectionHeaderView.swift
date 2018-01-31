//
//  SectionHeaderView.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 31.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView{
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
 
    
    var imageName: String!{
        didSet{
            categoryImageView.image = UIImage(named: imageName)
        }
    }
    
}
