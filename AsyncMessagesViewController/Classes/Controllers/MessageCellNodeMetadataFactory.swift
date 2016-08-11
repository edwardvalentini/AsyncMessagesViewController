//
//  MessageCellMetadataFactory.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public struct MessageCellNodeMetadata: Hashable {
    public let isOutgoing: Bool
    public let showsSenderName: Bool
    public let showsSenderAvatar: Bool
    public let showsTailForBubbleImage: Bool
    public let showsDate: Bool
    
    public var hashValue: Int {
        return (24 &* isOutgoing.hashValue) &+ (18 &* showsSenderName.hashValue) &+ (12 &* showsSenderAvatar.hashValue) &+ (6 &* showsTailForBubbleImage.hashValue) &+ showsDate.hashValue
    }
}

public func ==(lhs: MessageCellNodeMetadata, rhs: MessageCellNodeMetadata) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class MessageCellNodeMetadataFactory {
    
    public init() {
        
    }
    
    public func buildMetadatas(_ messages: [MessageData], currentUserID: String?) -> [MessageCellNodeMetadata] {
        var result = [MessageCellNodeMetadata]()
        if messages.isEmpty {
            return result
        }
        
        let showSenderNameFlags = showSenderNameFlagsForMessages(messages, currentUserID: currentUserID)
        let showSenderAvatarFlags = showSenderAvatarFlagsForMessages(messages)
        // Bubble image's tail points to sender's avatar. It should be shown only if the avatar is shown.
        let showTailFlags = showSenderAvatarFlags
        let showDateFlags = showDateFlagsForMessages(messages)
        
        for i in stride(from: 0, to: messages.count, by: 1) {
            let metadata = MessageCellNodeMetadata(
                isOutgoing: (messages[i].senderID() == currentUserID),
                showsSenderName: showSenderNameFlags[i],
                showsSenderAvatar: showSenderAvatarFlags[i],
                showsTailForBubbleImage: showTailFlags[i],
                showsDate: showDateFlags[i]
            )
            result.append(metadata)
        }
        
        return result
    }
    
    /**
        Generate flags indicate whether sender name should be shown for a given message or not.
        Sender name is shown if an incoming message is the fist one in consecutive ones sent by same sender.
    
        - parameter messages:
        - parameter currentUserID: used to detect outgoing messages.
    
        - returns: flags in the same order as messages param. `true` if sender name should be shown. `false` otherwise.
    */
    private func showSenderNameFlagsForMessages(_ messages: [MessageData], currentUserID: String?) -> [Bool] {
        var result = Array<Bool>(repeating: false, count: messages.count)
        
        result[0] = true
        
        for i in stride(from: (messages.count - 1), to: 0, by: -1) {
            let message = messages[i]
            if !message.senderDisplayName().isEmpty {
                let isOutgoing = (message.senderID() == currentUserID)
                let hasSameSenderAsPreviousMessage = message.senderID() == messages[i - 1].senderID()
                result[i] = !isOutgoing && !hasSameSenderAsPreviousMessage
            }
        }
        
        return result
    }

    /*
        Generate flags indicate whether sender avatar should be shown for a given message or not.
        Sender avatar is shown if a message is the last one in consecutive ones sent by same sender.
    
        :param: messages
    
        :returns: flags in the same order as messages param. `true` if sender avatar should be shown. `false` otherwise.
    */
    private func showSenderAvatarFlagsForMessages(_ messages: [MessageData]) -> [Bool] {
        var result = Array<Bool>(repeating: false, count: messages.count)
        
        result[messages.count - 1] = true
        
        for i in stride(from: 0, to: messages.count - 1, by: 1) {
            let hasSameSenderAsNextMessage = messages[i].senderID() == messages[i + 1].senderID()
            result[i] = !hasSameSenderAsNextMessage
        }
        
        return result
    }
    
    /**
        Generate flags indicate whether date should be shown for a given message or not.
        Date is shown if a message is the first one in consecutive ones sent within 15 minutes.
    
        - parameter messages:
        
        - returns: flags in the same order as messages param. `true` if date should be shown. `false` otherwise.
    */
    private func showDateFlagsForMessages(_ messages: [MessageData]) -> [Bool] {
        let dateInterval: Double = 15 * 60 // 15 minutes
        var result = Array<Bool>(repeating: false, count: messages.count)
        
        result[0] = true
        var lastShownDate = messages[0].date()
        
        for i in stride(from: 1, to: messages.count, by: 1) {
            let date = messages[i].date()
            if abs(date.timeIntervalSince(lastShownDate as Date)) >= dateInterval {
                result[i] = true
                lastShownDate = date
            }
        }
        
        return result
    }
    
}
