//
//  Message.swift
//  MyOwnChatApp
//
//  Created by Chris Chow on 13/2/2018.
//  Copyright © 2018 Yau On Chow. All rights reserved.
//

import Foundation

struct Message: Decodable {
    public private(set) var _id: String!
    public private(set) var messageBody: String!
    public private(set) var msgSender: String!
    public private(set) var __v: Int?
}
