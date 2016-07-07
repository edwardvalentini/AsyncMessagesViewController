//
//  Message.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import AsyncMessagesViewController

class Message: MessageData {

    private let _serializedContentType: String
    private let _content: String
    private let _date: NSDate
    private let sender: User
    
    init(serializedContentType: String, content: String, date: NSDate, sender: User) {
        _serializedContentType = serializedContentType
        _content = content
        _date = date
        self.sender = sender
    }
    
    @objc func contentType() -> String {
        return _serializedContentType
    }
    
    @objc func content() -> String {
        return _content
    }
    
    @objc func date() -> NSDate {
        return _date
    }
    
    @objc func senderID() -> String {
        return sender.ID
    }
    
    @objc func senderDisplayName() -> String {
        return sender.name
    }
    
    @objc func senderAvatarURL() -> NSURL {
        return sender.avatarURL
    }
   
}