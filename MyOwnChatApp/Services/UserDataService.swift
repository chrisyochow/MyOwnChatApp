//
//  File.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 10/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var userIdNumber = ""
    public private(set) var name = ""
    public private(set) var email = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    
    
    func setUserData(userIdNumber: String, name: String, email: String, avatarName: String, avatarColor: String) {
        self.userIdNumber = userIdNumber
        self.name = name
        self.email = email
        self.avatarName = avatarName
        self.avatarColor = avatarColor
    }
    
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
}
