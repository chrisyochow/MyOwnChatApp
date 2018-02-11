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
    
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_FIND_ALL_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let responseData = response.data else { return }

                do  {
                    self.channels = try JSONDecoder().decode([Channel].self, from: responseData)
                    completion(true)
                } catch let error {
                    debugPrint(error)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler) {
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
                
                if let json = try? JSON(data: responseData) {
                    let responseMsg = json["message"].stringValue
                    print(responseMsg)
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
    
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
