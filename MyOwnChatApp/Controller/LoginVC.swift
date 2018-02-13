//
//  LoginVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 8/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var loginBtn: RoundCornerButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        setupUserInteraction(enableOrNot: true)
        
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: lightPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: lightPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    
    func setupUserInteraction(enableOrNot: Bool) {
        self.emailTxt.isUserInteractionEnabled = enableOrNot
        self.passwordTxt.isUserInteractionEnabled = enableOrNot
        self.loginBtn.isUserInteractionEnabled = enableOrNot
        self.signUpBtn.isUserInteractionEnabled = enableOrNot
        self.closeBtn.isUserInteractionEnabled = enableOrNot
        self.coverView.isHidden = enableOrNot
        self.spinner.isHidden = enableOrNot
        if enableOrNot {
            self.spinner.stopAnimating()
            self.loginBtn.setTitle("Login", for: .normal)
        } else {
            spinner.startAnimating()
            self.loginBtn.setTitle(" ", for: .normal)
       }
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        setupUserInteraction(enableOrNot: false)
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                print("logged in user...")
                print("Auth Token: \(AuthService.instance.authToken)")
                
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        print("User found...")
                        print("User ID: \(UserDataService.instance.userIdNumber)")
                        print("Name: \(UserDataService.instance.name)")
                        print("Email: \(UserDataService.instance.email)")
                        print("Avatar Name: \(UserDataService.instance.avatarName)")
                        print("Avatar Color: \(UserDataService.instance.avatarColor)")
                        
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("Cannot find user...")
                    }
                    
//                    self.setupUserInteraction(enableOrNot: true)
                })
            } else {
                print("login failure...")
            }
                
            self.setupUserInteraction(enableOrNot: true)
        }
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
}
