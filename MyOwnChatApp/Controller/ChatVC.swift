//
//  ChatVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

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

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(70)

        burgerBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)

        setupView()
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
        if let channelName = MessageService.instance.selectedChannel?.name {
            channelNameLbl.text = channelName
        } else {
            if AuthService.instance.authToken != "" {
                channelNameLbl.text = "No Channel Selected"
            } else {
                channelNameLbl.text = "Please login"
            }
        }
    }
    
    
    @objc func channelSelected(_ notif: Notification) {
        setupView()
        getMessage()
        tableView.reloadData()
    }
    
    
    func getMessage() {
        let channelId = MessageService.instance.selectedChannel?._id ?? ""
        
        if channelId != "" {
            MessageService.instance.findAllMessageForChannel(channelId: channelId, completion: { (success) in
                if success {
                    print("Get messages successfully...")
                    print("No. of messages: \(MessageService.instance.channelMessages.count)")
                    for item in MessageService.instance.channels {
                        print("id: \(item._id), name: \(item.name), description: \(item.description)")
                    }
                } else {
                    print("cannot get messages")
                }
            })
        }
    }
    
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        guard let messageBody = messageTxt.text, messageTxt.text != nil else { return }
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
