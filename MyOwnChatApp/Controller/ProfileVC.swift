//
//  ProfileVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 10/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        avatarImg.image = UIImage(named: UserDataService.instance.avatarName)
        avatarImg.backgroundColor = UserDataService.instance.returnUIColor(component: UserDataService.instance.avatarColor)
        nameLbl.text = UserDataService.instance.name
        emailLbl.text = UserDataService.instance.email
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        AuthService.instance.logoutUser()
        UserDataService.instance.setUserData(userIdNumber: "", name: "", email: "", avatarName: "", avatarColor: "")
        MessageService.instance.clearChannels()
        
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
        
        print("logged out user...")
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
