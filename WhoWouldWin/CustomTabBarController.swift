//
//  CustomTabBarController.swift
//  WhoWouldWin
//
//  Created by Jakob on 10.01.18.
//  Copyright © 2018 HPJSVW. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class CustomTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! UIViewController
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! UIViewController
        let v3 = self.storyboard?.instantiateViewController(withIdentifier: "BattleViewController") as! BattleViewController
        let v4 = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! UIViewController
        let v5 = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! UIViewController
        
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(),title: "Home", image: UIImage(named: "tabbar_loc"), selectedImage: UIImage(named: "tabbar_loc"), tag: 0)
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(),title: "Find", image: UIImage(named: "tabbar_cat"), selectedImage: UIImage(named: "tabbar_cat"), tag: 1)
        
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "tabbar_vs"), selectedImage: UIImage(named: "tabbar_vs"), tag: 2)
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(),title: "Favor", image: UIImage(named: "tabbar_add"), selectedImage: UIImage(named: "tabbar_add"), tag: 3)
        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(),title: "Me", image: UIImage(named: "tabbar_settings"), selectedImage: UIImage(named: "tabbar_settings"), tag: 4)
        
        self.viewControllers = [v1, v2, v3, v4, v5]
        
        self.delegate = self
    }



}
extension CustomTabBarController : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    //other delegate methods as required....
}
