//
//  CardViewController.swift
//  daisiebank
//
//  Created by Nick Donovan on 05/11/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import UIKit
class CardViewController: UIViewController{
    //Init view from storyboard file method
    static func storyboardInstance() -> CardViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? CardViewController
    }
    
    override func viewDidLoad() {
        
    }
}
