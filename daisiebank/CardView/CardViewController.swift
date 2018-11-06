//
//  CardViewController.swift
//  daisiebank
//
//  Created by Nick Donovan on 05/11/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import UIKit
class CardViewController: UIViewController{
    //IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var upnLabel: UILabel!
    @IBOutlet var addMoneyButton: UIButton!
    @IBOutlet var balanceLabel: UILabel!
    
    //Init view from storyboard file method
    static func storyboardInstance() -> CardViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? CardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.image = UIImage(named: "placeholder")
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2
        
        self.addMoneyButton.backgroundColor = Stylesheet.Colors.ButtonPurple
        self.addMoneyButton.tintColor = UIColor.white
        self.addMoneyButton.layer.cornerRadius = 5
        self.addMoneyButton.clipsToBounds = true
        
        self.balanceLabel.text = "Balance: £7.00"
        
    }
}
