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
    
    @IBOutlet weak var coverView: UIView!
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
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: COLOR_LIGHT_PURPLE])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: COLOR_LIGHT_PURPLE])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: COLOR_LIGHT_PURPLE])
        
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
        self.coverView.isHidden = enableOrNot
        self.spinner.isHidden = enableOrNot
        if enableOrNot {
            self.spinner.stopAnimating()
            self.createBtn.setTitle("Sign Up", for: .normal)
        } else {
            self.spinner.startAnimating()
            self.createBtn.setTitle(" ", for: .normal)
        }
    }
    
    @IBAction func createBtnPassed(_ sender: Any) {
        guard let name = usernameTxt.text, usernameTxt.text != "" else { return }
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        if UserDataService.instance.avatarName == "" { return }
        
        setupUserInteraction(enableOrNot: false)

        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("ChitChat: registered user as '\(name)'...")
                
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        print("ChitChat: logged in as '\(name)'...")
                        
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print("ChitChat: user account '\(name)' created...")

                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            } else {
                                print("ChitChat: cannot create user '\(name)'...")
                            }
                        })
                    } else {
                        print("ChitChat: cannot login as '\(name)'...")
                    }
                })
            } else {
                print("ChitChat: cannot register user as '\(name)'...")
            }
        }
    }
    
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    
    @IBAction func chooseBgColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        self.avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.3) {
            self.avatarImg.backgroundColor = self.bgColor
        }
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        AuthService.instance.logoutUser()
        UserDataService.instance.setUserData(userIdNumber: "", name: "", email: "", avatarName: "", avatarColor: "")
        MessageService.instance.clearChannels()
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
