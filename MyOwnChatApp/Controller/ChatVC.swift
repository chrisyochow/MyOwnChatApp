//
//  ChatVC.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 7/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

@IBDesignable
class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var isTypingLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var burgerBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        messageTxt.delegate = self
        
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
        
        burgerBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelMessagesLoaded(_:)), name: NOTIF_CHANNEL_MESSAGES_LOADED, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        if AuthService.instance.isLoggedIn {
            findAllChannels()
        }
        
        setupView()
        
        SocketService.instance.observeMessages { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    
//    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//    }
//    
//    
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
        var msgTxtPlaceholder = "No Channel Selected"
        
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
    
    
    func setupUserInteraction(enableOrNot: Bool) {
        
    }
    
    
    func findAllChannels() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                
                if MessageService.instance.channels.count > 0 {
                    if MessageService.instance.selectedChannel == nil || MessageService.instance.selectedChannel?._id == "" {
                        MessageService.instance.channelSeleted(row: 0)
                        if let selectedChannelId = MessageService.instance.selectedChannel?._id {
                            self.loadMessagesForSelectedChannel(selectedChannelId: selectedChannelId)
                        }
                    }
                }
            } else {
                print("cannot get channels")
            }
        }
    }
    
    
    func loadMessagesForSelectedChannel(selectedChannelId: String) {
        MessageService.instance.findAllMessagesForSelecgtedChannel(channelId: selectedChannelId, completion: { (success) in
            if success {
                print("ChitChat: \(MessageService.instance.channelMessages.count) messages loaded for the selected channel (#\(selectedChannelId))...")
                NotificationCenter.default.post(name: NOTIF_CHANNEL_MESSAGES_LOADED, object: nil)
            } else {
                print("ChitChat: cannot find channel messages...")
            }
        })
    }
    
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            findAllChannels()
        } else {
            setupView()
            tableView.reloadData()
        }
    }
    
    
    @objc func channelSelected(_ notif: Notification) {
        if let selectedChannelId = MessageService.instance.selectedChannel?._id {
            self.loadMessagesForSelectedChannel(selectedChannelId: selectedChannelId)
        }
    }
    
    @objc func channelMessagesLoaded(_ notif: Notification) {
        setupView()
        tableView.reloadData()
        print("ChitChat: tableView reloaded...")
    }
    
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        if messageTxt.isEditing {
            messageTxt.resignFirstResponder()
        }
    }
    
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let keyboardCurrentFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardFinishFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let yMovement = keyboardFinishFrame.origin.y - keyboardCurrentFrame.origin.y
//        let bottomYCoordinate = tableView.frame.size.height - yMovement
//        let tableViewBottom: CGPoint = CGPoint(x: 0.0, y: 75)
//        let contentInset = tableView.contentInset
        
        if messageTxt.isFirstResponder {
//            self.bottomView.frame.origin.y += yMovement
            textFieldToBottomLayoutGuideConstraint.constant -= yMovement
        }
        
        view.layoutIfNeeded()
        
//        print("Bottom: \(tableView.contentInset.bottom)")

        if yMovement > 0 {
            let contentInsets:UIEdgeInsets = UIEdgeInsets.zero
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            print("TableView Height: \(tableView.frame.size.height)")
            print("Content Height: \(tableView.contentSize.height)")
        } else {
            if MessageService.instance.channelMessages.count > 0 {
                let lastRowIndex = MessageService.instance.channelMessages.count - 1
                 let sectionIndex = tableView.numberOfSections - 1
                let lastIndexPath: IndexPath = IndexPath(item: lastRowIndex, section: sectionIndex)
                self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
            print("TableView Height: \(tableView.frame.size.height)")
            print("Content Height: \(tableView.contentSize.height)")
        }
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
