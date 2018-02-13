//
//  MessageService.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 10/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var channelMessages = [Message]()
    
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_FIND_ALL_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let responseData = response.data else { return }

                do  {
                    self.channels = try JSONDecoder().decode([Channel].self, from: responseData)
                    completion(true)
                } catch let error {
                    debugPrint(error)
                    completion(false)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_FIND_ALL_CHANNELS)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let responseData = response.data else { return }
                
//                do  {
//                    self.channelMessages = try JSONDecoder().decode([Message].self, from: responseData)
//                    completion(true)
//                } catch let error {
//                    debugPrint(error)
//                    completion(false)
//                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        completion(true)
    }
    
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "name": channelName,
            "description": channelDescription
        ]
        
        Alamofire.request(URL_ADD_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let responseData = response.data else { return }
                
                do {
                    let json = try JSON(data: responseData)
                    let responseMsg = json["message"].stringValue
                    if responseMsg == ADD_CHANNEL_SUCCESS {
                        completion(true)
                    } else {
                       completion(false)
                    }
                } catch let error {
                    debugPrint(error)
                    completion(false)
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
