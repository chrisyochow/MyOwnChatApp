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

//Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
