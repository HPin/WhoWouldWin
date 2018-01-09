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
    var categories = [String]()
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        refHandle = ref?.child("Categories").observe(.childAdded, with: { (snapshot) in
            
            let post = snapshot.key
            
            self.categories.append(post)
            self.reloadCollectionView()
            
        })
        
        
        
        
        let itemSize = UIScreen.main.bounds.width - 20   // - 3 because we use 3 pts spacing
        
        let customLayout = UICollectionViewFlowLayout()
        customLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)  // not really necessary
        customLayout.itemSize = CGSize(width: itemSize, height: 120)
        customLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        
        customLayout.minimumInteritemSpacing = 20
        customLayout.minimumLineSpacing = 20
        
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
        cell.nameLabel.text = categories[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "categorySegue", sender: self)
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
