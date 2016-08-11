//
//  MessageNetworkImageBubbleNodeFactory.swift
//  Pods
//
//  Created by Edward Valentini on 7/7/16.
//
//

import Foundation
import AsyncDisplayKit


public class MessageNetworkImageBubbleNodeFactory: MessageBubbleNodeFactory {
    
    public func build(_ message: MessageData, isOutgoing: Bool, bubbleImage: UIImage) -> ASDisplayNode {
        let URL = Foundation.URL(string: message.content())
        return MessageNetworkImageBubbleNode(URL: URL, bubbleImage: bubbleImage)
    }
    
    public init() {
        
    }
    
}
