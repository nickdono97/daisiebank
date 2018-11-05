//
//  MasterTabBarController.swift
//  daisiebank
//
//  Created by Nick Donovan on 30/10/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import Foundation
import UIKit



class MasterTabBarController: UITabBarController {
    static func storyboardInstance() -> MasterTabBarController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? MasterTabBarController
    }
    
    //MARK: - Tab bar UI set up
    override func viewDidLoad() {
        tabBar.tintColor = Stylesheet.Colors.ButtonPurple
        
        //Set up tab bar view controllers with tab items
        if let transactionViewController = TransactionViewController.storyboardInstance(){
            transactionViewController.tabBarItem = UITabBarItem.init(title: "Transactions", image: UIImage.init(named: "home"), tag: 0)
            let controllers = [transactionViewController]
            selectedIndex = 0
            viewControllers = controllers
            

        }else{
            //Error view
            
        }
    }
}
