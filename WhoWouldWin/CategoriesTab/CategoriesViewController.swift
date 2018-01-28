//
//  CategoriesViewController.swift
//  WhoWouldWin
//
//  Created by HP on 06.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var categories = ["Beauty Contest", "Dance Battle", "Fight", "Rap Battle"]
    var categoryClicked: String?
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ref = Database.database().reference()
//
//        refHandle = ref?.child("Categories").observe(.childAdded, with: { (snapshot) in
//
//            let post = snapshot.key
//
//            self.categories.append(post)
//            self.reloadCollectionView()
//
//        })
        
        
        
        
        let itemSize = UIScreen.main.bounds.width - 20   // - 3 because we use 3 pts spacing
        
        let customLayout = UICollectionViewFlowLayout()
        customLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)  // not really necessary
        customLayout.itemSize = CGSize(width: itemSize, height: 120)
        customLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        
        customLayout.minimumInteritemSpacing = 10
        customLayout.minimumLineSpacing = 10
        
        categoriesCollectionView.collectionViewLayout = customLayout
        
        reloadCollectionView()
    }
    
    func reloadCollectionView() {
        categoriesCollectionView?.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        //CoursesCollectionView.layer.cornerRadius = CoursesCollectionView.frame.size.height / 2
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.picImageView.image = UIImage(named: "beautyContest.jpg")
        case 1:
            cell.picImageView.image = UIImage(named: "danceBattle3.jpg")
        case 2:
            cell.picImageView.image = UIImage(named: "fight2.jpg")
        case 3:
            cell.picImageView.image = UIImage(named: "rapBattle1.jpg")
        default:
            print("invalid indexpath")
        }
        
        let textAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -1,
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 40)
        ] as [NSAttributedStringKey : Any]
        
        let name = categories[indexPath.row]
        cell.nameLabel.attributedText = NSAttributedString(string: name, attributes: textAttributes)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        categoryClicked = categories[indexPath.row]
        
        performSegue(withIdentifier: "categorySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categorySegue" {
            if let detailsVC = segue.destination as? CategoryBattleViewController {
                
                detailsVC.categoryName = self.categoryClicked
                
            }
        }
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
