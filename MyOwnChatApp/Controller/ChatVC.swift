//
//  ChatVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

@IBDesignable
class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var burgerBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
        
        burgerBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
//            AuthService.instance.findUserByEmail(completion: { (success) in
//                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
//            })
            findAllChannels()
        }
        
        setupView()
        
        SocketService.instance.observeMessages { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channelMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            cell.configureCell(message: MessageService.instance.channelMessages[indexPath.row])
            return cell
        }
        return MessageCell()
    }
    
    
    func setupView() {
        var msgTxtPlaceholder = "No Channel"
        
        if let channelName = MessageService.instance.selectedChannel?.name, MessageService.instance.selectedChannel?.name != "" {
            channelNameLbl.text = "#\(channelName)"
            msgTxtPlaceholder = "Message to #\(channelName)"
            messageTxt.isEnabled = true
            sendBtn.isEnabled = true
        } else {
            if AuthService.instance.authToken != "" {
                channelNameLbl.text = "Please select a channel"
            } else {
                channelNameLbl.text = "Please login"
            }
            messageTxt.isEnabled = false
            sendBtn.isEnabled = false
        }
        
        messageTxt.attributedPlaceholder = NSAttributedString(string: msgTxtPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: COLOR_LIGHT_PURPLE])
    }
    
    
    func findAllChannels() {
        MessageService.instance.findAllChannels { (success) in
            if success {
//                print("Get channels successfully...")
//                for item in MessageService.instance.channels {
//                    print("id: \(item._id), name: \(item.name), description: \(item.description)")
//                }
                
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                
                if MessageService.instance.channels.count > 0 {
                    if MessageService.instance.selectedChannel == nil || MessageService.instance.selectedChannel?.name == "" {
                        MessageService.instance.channelSeleted(row: 0, completion: { (success) in
                            if success {
                                print("ChitChat: the first channel is selected...")
                                //NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
                            }
                        })
                    }
                }
            } else {
                print("cannot get channels")
            }
        }
    }
    
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupView()
        tableView.reloadData()
        if AuthService.instance.isLoggedIn {
            findAllChannels()
        }
    }
    
    
    @objc func channelSelected(_ notif: Notification) {
        setupView()
        tableView.reloadData()
    }
    
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        guard let messageBody = messageTxt.text, messageTxt.text != "" else { return }
        guard let channelId = MessageService.instance.selectedChannel?._id else { return }

        let userId = UserDataService.instance.userIdNumber
        let userName = UserDataService.instance.name
        let avatarName = UserDataService.instance.avatarName
        let avatarColor = UserDataService.instance.avatarColor
        
        SocketService.instance.addMessage(messageBody: messageBody, userId: userId, channelId: channelId, userName: userName, avatarName: avatarName, avatarColor: avatarColor) { (success) in
            if success {
                print("a message is sent...")
                self.messageTxt.text = ""
            } else {
                print("cannot send a message...")
            }
        }
    }
    
}
