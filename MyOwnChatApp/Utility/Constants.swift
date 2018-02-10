//
//  Constants.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 8/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import Foundation

//Handler
typealias CompletionHandler = (_ Success: Bool) -> ()

//URL
let BASE_URL = "https://mychitchatapp.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_ADD_USER = "\(BASE_URL)user/add"

//Colors
let lightPurplePlaceholder = #colorLiteral(red: 0.3266413212, green: 0.4215201139, blue: 0.7752227187, alpha: 0.5)

//Notification
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")

//Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let TO_AVATAR_PICKER = "toAvatarPicker"
let UNWIND = "unwindToChannel"

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
