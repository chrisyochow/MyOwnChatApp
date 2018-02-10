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
let URL_REGISTER = "\(BASE_URL)account/register/"
let URL_LOGIN = "\(BASE_URL)account/login/"
let URL_ADD_USER = "\(BASE_URL)user/add/"
let URL_FIND_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_FIND_ME = "\(BASE_URL)account/me/"
let URL_FIND_ALL_CHANNELS = "\(BASE_URL)channel/"

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

//Web Requests
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization":"Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]

