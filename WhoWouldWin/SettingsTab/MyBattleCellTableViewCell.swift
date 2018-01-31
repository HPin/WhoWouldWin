//
//  MyBattleCellTableViewCell.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 31.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit

class MyBattleCellTableViewCell: UITableViewCell {

    @IBOutlet weak var Contender1Label: UILabel!
    @IBOutlet weak var Contender2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
