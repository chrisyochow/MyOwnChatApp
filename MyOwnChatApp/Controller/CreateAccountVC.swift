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
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var createBtn: RoundCornerButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var pickAvatarBtn: UIButton!
    @IBOutlet weak var pickBgColorBtn: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            avatarName = UserDataService.instance.avatarName
            avatarImg.image = UIImage(named: avatarName)
            
            if avatarName.contains("light") && bgColor == nil {
                avatarImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    
    func setupView() {
        setupUserInteraction(enableOrNot: true)
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: lightPurplePlaceholder])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: lightPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: lightPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    
    func setupUserInteraction(enableOrNot: Bool) {
        self.usernameTxt.isUserInteractionEnabled = enableOrNot
        self.emailTxt.isUserInteractionEnabled = enableOrNot
        self.passwordTxt.isUserInteractionEnabled = enableOrNot
        self.avatarImg.isUserInteractionEnabled = enableOrNot
        self.createBtn.isUserInteractionEnabled = enableOrNot
        self.closeBtn.isUserInteractionEnabled = enableOrNot
        self.pickAvatarBtn.isUserInteractionEnabled = enableOrNot
        self.pickBgColorBtn.isUserInteractionEnabled = enableOrNot
        self.spinner.isHidden = enableOrNot
        if enableOrNot {
            self.spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }
    
    @IBAction func createBtnPassed(_ sender: Any) {
        setupUserInteraction(enableOrNot: false)
        
        guard let name = usernameTxt.text, usernameTxt.text != "" else { setupUserInteraction(enableOrNot: true); return }
        guard let email = emailTxt.text, emailTxt.text != "" else { setupUserInteraction(enableOrNot: true); return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { setupUserInteraction(enableOrNot: true); return }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("registered user")
                
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    
                    if success {
                        print("logged in user!", AuthService.instance.authToken)
                        
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            
                            if success {
                                print("user account created")
                                print("User ID: \(UserDataService.instance.userIdNumber)")
                                print("Name: \(UserDataService.instance.name)")
                                print("Email: \(UserDataService.instance.email)")
                                print("Avatar Name: \(UserDataService.instance.avatarName)")
                                print("Avatar Color: \(UserDataService.instance.avatarColor)")
                                
                                self.setupUserInteraction(enableOrNot: true)
                                
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    @IBAction func avatarImageTapped(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    
    @IBAction func chooseBgColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        UIView.animate(withDuration: 0.3) {
            self.avatarImg.backgroundColor = self.bgColor
        }
        
        self.avatarColor = "[\(r), \(g), \(b), 1]"
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        UserDataService.instance.setUserData(userIdNumber: "", name: "", email: "", avatarName: "", avatarColor: "")
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
