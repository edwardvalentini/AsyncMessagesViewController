//
//  User.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation

class User {
    
    let ID: String
    let name: String
    let avatarURL: URL
    
    init(ID: String, name: String, avatarURL: URL) {
        self.ID = ID
        self.name = name
        self.avatarURL = avatarURL
    }
    
}
