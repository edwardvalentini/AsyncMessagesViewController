//
//  MessageTextBubbleNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 13/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit


private class MessageTextNode: ASTextNode {
    
    override init() {
        super.init()
        placeholderColor = UIColor.gray
        isLayerBacked = true
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        let size = super.calculateSizeThatFits(constrainedSize)
        return CGSize(width: max(size.width, 15), height: size.height)
    }
    
}

public class MessageTextBubbleNode: ASDisplayNode {

    private let isOutgoing: Bool
    private let bubbleImageNode: ASImageNode
    private let textNode: ASTextNode
    
    public init(text: NSAttributedString, isOutgoing: Bool, bubbleImage: UIImage) {
        self.isOutgoing = isOutgoing

        bubbleImageNode = ASImageNode()
        bubbleImageNode.image = bubbleImage

        textNode = MessageTextNode()
        textNode.attributedText = text
        
        super.init()
        
        addSubnode(bubbleImageNode)
        addSubnode(textNode)
    }
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textNodeVerticalOffset = CGFloat(6)
        
        return ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(
                    12,
                    12 + (isOutgoing ? 0 : textNodeVerticalOffset),
                    12,
                    12 + (isOutgoing ? textNodeVerticalOffset : 0)),
                child: textNode),
            background: bubbleImageNode)
    }
    
}
