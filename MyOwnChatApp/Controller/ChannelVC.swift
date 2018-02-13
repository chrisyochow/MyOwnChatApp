//
//  ChannelVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var avatarImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 50
        
        setupUserInfo()
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelListUpdated(_:)), name: NOTIF_CHANNEL_LIST_UPDATED, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            cell.configureCell(channel: MessageService.instance.channels[indexPath.row])
            return cell
        }
        return ChannelCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
        tableView.reloadData()
    }
    
    
    @objc func channelListUpdated(_ notif: Notification) {
        tableView.reloadData()
    }
    
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            avatarImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarImg.backgroundColor = UserDataService.instance.returnUIColor(component: UserDataService.instance.avatarColor)
            getChannels()
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
                NotificationCenter.default.post(name: NOTIF_CHANNEL_LIST_UPDATED, object: nil)
            } else {
                print("cannot get channels")
            }
        }
    }

    
    @IBAction func addChannelBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn, UserDataService.instance.name != "" {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
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
