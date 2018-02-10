//
//  ChannelVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var avatarImg: CircleImage!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 50
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
        getChannels()
    }
    
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            avatarImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarImg.backgroundColor = UserDataService.instance.returnUIColor(component: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            avatarImg.image = UIImage(named: "menuProfileIcon")
            avatarImg.backgroundColor = UIColor.clear
        }
    }
    
    
    func getChannels() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                print("Get channels successfully")
                for item in MessageService.instance.channels {
                    print("id: \(item._id), name: \(item.name), description: \(item.description)")
                }
                
            } else {
                print("unsuccessful")
            }
        }
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn, UserDataService.instance.name != "" {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
}
