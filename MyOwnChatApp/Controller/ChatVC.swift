//
//  ChatVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

@IBDesignable
class ChatVC: UIViewController {

    @IBOutlet weak var burgerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        burgerBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

}
