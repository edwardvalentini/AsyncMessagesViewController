//
//  Messaging.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

//public typealias MessageDataContentType = Int
//public let kAMMessageDataContentTypeText: MessageDataContentType = 0
//public let kAMMessageDataContentTypeNetworkImage: MessageDataContentType = 1

@objc public protocol MessageData {
    
    @objc func contentType() -> String
    
    @objc func content() -> String
    
    @objc func date() -> Date
    
    @objc func senderID() -> String
    
    @objc func senderDisplayName() -> String
    
    @objc func senderAvatarURL() -> URL
    
}
