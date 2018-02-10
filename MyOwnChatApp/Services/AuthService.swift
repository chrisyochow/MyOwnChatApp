//
//  AuthService.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 9/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults  = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
        
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
        
    }
   
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
        
    }
    
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()

        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let responseData = response.data else { return }
                if let json = try? JSON(data: responseData) {
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
    
        let header = [
            "Authorization":"Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        Alamofire.request(URL_ADD_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                guard let responseData = response.data else { return }
                if let json = try? JSON(data: responseData) {
                    let userIdNumber = json["_id"].stringValue
                    let name = json["name"].stringValue
                    let email = json["email"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let avatarColor = json["avatarColor"].stringValue
                    
                    UserDataService.instance.setUserData(userIdNumber: userIdNumber, name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
                    
                    completion(true)
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func logoutUser() {
        userEmail = ""
        authToken = ""
        isLoggedIn = false
    }
    
}
