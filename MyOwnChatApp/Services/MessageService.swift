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
        
    }
    
}
