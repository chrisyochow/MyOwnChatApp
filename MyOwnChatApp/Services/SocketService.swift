//
//  SocketService.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 12/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    let socketManager = SocketManager(socketURL: URL(string:URL_BASE)!)

    override init() {
        super.init()
    }
    
    
    func establishSocketConnection() {
        socketManager.connect()
    }
    
    
    func closeSocketConnection() {
        socketManager.disconnect()
    }
    
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        let socket: SocketIOClient = socketManager.defaultSocket
        socket.connect()
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
        
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        let socket: SocketIOClient = socketManager.defaultSocket
        socket.connect()
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(_id: channelId, description: channelDescription, name: channelName, __v: 0)
            
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
}
