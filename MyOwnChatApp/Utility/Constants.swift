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
let URL_BASE = "https://mychitchatapp.herokuapp.com/v1/"
let URL_REGISTER = "\(URL_BASE)account/register/"
let URL_LOGIN = "\(URL_BASE)account/login/"
let URL_ADD_USER = "\(URL_BASE)user/add/"
let URL_ADD_CHANNEL = "\(URL_BASE)channel/add/"
let URL_FIND_USER_BY_EMAIL = "\(URL_BASE)user/byEmail/"
let URL_FIND_ME = "\(URL_BASE)account/me/"
let URL_FIND_ALL_CHANNELS = "\(URL_BASE)channel/"
let URL_FIND_ALL_MESSAGES_FOR_SELECTED_CHANNEL = "\(URL_BASE)message/byChannel/"


//Colors
let COLOR_LIGHT_PURPLE = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 0.5)
let COLOR_DARK_BLUE = #colorLiteral(red: 0.2221058011, green: 0.2798659205, blue: 0.6172473431, alpha: 1)
let COLOR_ICE = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)


//Notification
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("notifChannelsLoaded")
let NOTIF_CHANNEL_MESSAGES_LOADED = Notification.Name("notifChannelMessagesLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("notifChannelSeleted")


//Segues
let TO_SWREVEAL = "toSWReveal"
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


//API Response
let ADD_CHANNEL_SUCCESS = "Channel saved successfully"
let LOGIN_FAILURE = "Email or password invalid, please check your credentials"


//Socket
let NEW_CHANNEL = "newChannel"
let CHANNEL_CREATED = "channelCreated"
let NEW_MESSAGE = "newMessage"
let MESSAGE_CREATED = "messageCreated"
