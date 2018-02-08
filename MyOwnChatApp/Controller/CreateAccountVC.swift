//
//  CreateAccountVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 8/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

@IBDesignable
class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
