//
//  MessageCell.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 14/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageBodyLbl: UILabel!
    
    @IBOutlet weak var avatarImg: CircleImage!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(message: Message) {
        let userName = message.userName ?? "NoName"
        let timeStamp = message.timeStamp ?? "NoTime"
        let messageBody = message.messageBody ?? "NoMessage"
        let avatarName = message.userAvatar ?? "profileDefault"
        let avatarColor = message.userAvatarColor ?? "[0.5, 0.5, 0.5, 1"
    
        avatarImg.image = UIImage(named: avatarName)
        avatarImg.backgroundColor = UserDataService.instance.returnUIColor(component: avatarColor)
        userNameLbl.text = userName
        timeStampLbl.text = timeStamp
        messageBodyLbl.text = messageBody
    }
    
}
