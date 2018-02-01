//
//  MyBattleShowViewController.swift
//  WhoWouldWin
//
//  Created by Valentin Witzeneder on 01.02.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit

class MyBattleShowViewController: UIViewController {
    
    struct battle {
        var categoryname: String
        var Contender1: String
        var Image1: String
        var Votes1: Double
        var Contender2: String
        var Image2: String
        var Votes2: Double
    }
    
    var categoryname = ""
    var contenderName1 = ""
    var contenderName2 = ""
    var contenderVotes1 = 0.0
    var contenderVotes2 = 0.0
    var contenderImage1 = ""
    var contenderImage2 = ""
    

    
    @IBOutlet weak var contender1Name: UILabel!
    @IBOutlet weak var contender1Image: UIImageView!
    @IBOutlet weak var contender1Percentage: UILabel!
    @IBOutlet weak var contender1WinOrLoseImage: UIImageView!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var contender2Percentage: UILabel!
    @IBOutlet weak var contender2WinOrLoseImage: UIImageView!
    @IBOutlet weak var contender2Image: UIImageView!
    @IBOutlet weak var contender2Name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let myBattle = battle(categoryname: categoryname, Contender1: contenderName1, Image1: contenderImage1, Votes1: contenderVotes1, Contender2: contenderName2, Image2: contenderImage2, Votes2: contenderVotes2)
        self.title = myBattle.categoryname
        self.title?.append(" |Total Votes: ")
        
        contender1Name.text = myBattle.Contender1
        contender2Name.text = myBattle.Contender2
        let totalVotes = myBattle.Votes1 + myBattle.Votes2
        let contender1Perc = (myBattle.Votes1/totalVotes)*100
        let contender2Perc = (myBattle.Votes2/totalVotes)*100
        self.title?.append(String(Int(totalVotes)))
        contender1Percentage.text = String(contender1Perc)
        contender1Percentage.text?.append("%")
        contender2Percentage.text = String(contender2Perc)
        contender2Percentage.text?.append("%")
        var catText = "cell"
        catText.append(myBattle.categoryname)
        categoryImage?.image = UIImage(named: catText)
        
        if contender1Perc > contender2Perc {
            contender1WinOrLoseImage.image = UIImage(named: "winnerup")
            contender2WinOrLoseImage.image = UIImage(named: "loserdown")
            contender1Name.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            contender2Name.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            contender1Percentage.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            contender2Percentage.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }
        else if contender2Perc > contender1Perc{
            contender1WinOrLoseImage.image = UIImage(named: "loserup")
            contender2WinOrLoseImage.image = UIImage(named: "winnerdown")
            contender1Name.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            contender2Name.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            contender1Percentage.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            contender2Percentage.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }
        else{
            contender1WinOrLoseImage.image = UIImage(named: "equal")
            contender2WinOrLoseImage.image = UIImage(named: "equal")
            contender1Name.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            contender2Name.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            contender1Percentage.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            contender2Percentage.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            if totalVotes == 0{
                contender1Percentage.text = "-"
                contender2Percentage.text = "-"
            }
        }
        
        
        let url = URL(string: myBattle.Image1)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {   // if download not successful, close url session
                print(error)
                return
            }
            DispatchQueue.main.async {  // get main UI thread
                self.contender1Image.image = UIImage(data: data!)
            }
        }).resume()
        
        let url1 = URL(string: myBattle.Image2)
        URLSession.shared.dataTask(with: url1!, completionHandler: { (data, response, error) in
            if error != nil {   // if download not successful, close url session
                print(error)
                return
            }
            DispatchQueue.main.async {  // get main UI thread
                self.contender2Image.image = UIImage(data: data!)
            }
        }).resume()
        
        
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
