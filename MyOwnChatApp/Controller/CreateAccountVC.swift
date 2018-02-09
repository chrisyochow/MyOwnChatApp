//
//  CreateAccountVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 8/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    
    @IBAction func createBtnPassed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("registered user")
            }
        }
    }
    
    
    @IBAction func pickAvatarPassed(_ sender: Any) {
        
    }
    
    
    @IBAction func pickBGColorPassed(_ sender: Any) {
        
    }
    
}
