//
//  MessageTextBubbleNodeFactory.swift
//  Pods
//
//  Created by Edward Valentini on 7/7/16.
//
//

import Foundation
import AsyncDisplayKit


private let kAMMessageTextBubbleNodeIncomingTextAttributes = [NSForegroundColorAttributeName: AsyncMessagesConfiguration.defaultIncomingTextFontColor,
                                                              NSFontAttributeName: UIFont.systemFontOfSize(AsyncMessagesConfiguration.defaultTextSize)]
private let kAMMessageTextBubbleNodeOutgoingTextAttributes = [NSForegroundColorAttributeName: AsyncMessagesConfiguration.defaultOutgoingTextFontColor,
                                                              NSFontAttributeName: UIFont.systemFontOfSize(AsyncMessagesConfiguration.defaultTextSize)]



public class MessageTextBubbleNodeFactory: MessageBubbleNodeFactory {
    
    public func build(message: MessageData, isOutgoing: Bool, bubbleImage: UIImage) -> ASDisplayNode {
        let attributes = isOutgoing
            ? kAMMessageTextBubbleNodeOutgoingTextAttributes
            : kAMMessageTextBubbleNodeIncomingTextAttributes
        let text = NSAttributedString(string: message.content(), attributes: attributes)
        return MessageTextBubbleNode(text: text, isOutgoing: isOutgoing, bubbleImage: bubbleImage)
    }
    
    public init() {
        
    }
    
}