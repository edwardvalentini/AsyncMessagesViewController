//
//  MessageCellNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 12/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public let kAMMessageCellNodeAvatarImageSize: CGFloat = 34

public let kAMMessageCellNodeTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray,
                                                  NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)]
public let kAMMessageCellNodeContentTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray,
                                                         NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
public let kAMMessageCellNodeBottomTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray,
                                                     NSFontAttributeName: UIFont.systemFont(ofSize: 11)]

public class MessageCellNode: ASCellNode {
    private let isOutgoing: Bool
    private let topTextNode: ASTextNode?
    private let contentTopTextNode: ASTextNode?
    private let bottomTextNode: ASTextNode?
    private let bubbleNode: ASDisplayNode
    private let avatarImageSize: CGFloat
    private let avatarImageNode: ASNetworkImageNode?
    
    public init(isOutgoing: Bool, topText: NSAttributedString?, contentTopText: NSAttributedString?, bottomText: NSAttributedString?, senderAvatarURL: URL?, senderAvatarImageSize: CGFloat = kAMMessageCellNodeAvatarImageSize, bubbleNode: ASDisplayNode) {
        self.isOutgoing = isOutgoing
        
        topTextNode = topText != nil ? ASTextNode() : nil
        topTextNode?.isLayerBacked = true
        topTextNode?.attributedText = topText
        topTextNode?.style.alignSelf = .center
        
        contentTopTextNode = contentTopText != nil ? ASTextNode() : nil
        contentTopTextNode?.isLayerBacked = true
        contentTopTextNode?.attributedText = contentTopText
        
        avatarImageSize = senderAvatarImageSize
        avatarImageNode = avatarImageSize > 0 ? ASNetworkImageNode() : nil
        avatarImageNode?.style.preferredSize = CGSize(width: avatarImageSize, height: avatarImageSize)
        avatarImageNode?.backgroundColor = UIColor.clear
        avatarImageNode?.imageModificationBlock = { (image: UIImage) -> UIImage in
            let preferredSize = CGSize(width: senderAvatarImageSize, height: senderAvatarImageSize)
            let newImage = image.makeCircularImageWithSize(preferredSize)
            return newImage
        }
        avatarImageNode?.url = senderAvatarURL
        
        self.bubbleNode = bubbleNode
        self.bubbleNode.style.flexShrink = 1.0
        
        bottomTextNode = bottomText != nil ? ASTextNode() : nil
        bottomTextNode?.isLayerBacked = true
        bottomTextNode?.attributedText = bottomText
        
        super.init()
        
        if let node = topTextNode { addSubnode(node) }
        if let node = contentTopTextNode { addSubnode(node) }
        if let node = avatarImageNode { addSubnode(node) }
        addSubnode(bubbleNode)
        if let node = bottomTextNode { addSubnode(node) }
        
        selectionStyle = .none
    }
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentTopFinal : ASLayoutSpec? = contentTopTextNode == nil ? nil : ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 22 + avatarImageSize, 0, 0), child: contentTopTextNode!)
        
        let horizontalSpec = ASStackLayoutSpec()
        horizontalSpec.style.width = ASDimensionMakeWithPoints(constrainedSize.max.width)
        horizontalSpec.direction = .horizontal
        horizontalSpec.spacing = 2
        horizontalSpec.justifyContent = .start
        horizontalSpec.verticalAlignment = .verticalAlignmentBottom

        if isOutgoing {
            horizontalSpec.setChild(bubbleNode, at: 0)
            horizontalSpec.setChild(self.avatarImageNode!, at: 1)
            horizontalSpec.style.alignSelf = .end
            horizontalSpec.horizontalAlignment = .horizontalAlignmentRight
            
        } else {
            horizontalSpec.setChild(self.avatarImageNode!, at: 0)
            horizontalSpec.setChild(bubbleNode, at: 1)
            horizontalSpec.style.alignSelf = .end
            horizontalSpec.horizontalAlignment = .horizontalAlignmentLeft
        }
        
        horizontalSpec.style.flexShrink = 1.0
        horizontalSpec.style.flexGrow = 1.0
        
        let verticalSpec = ASStackLayoutSpec()
        verticalSpec.direction = .vertical
        verticalSpec.spacing = 0
        verticalSpec.justifyContent = .start
        verticalSpec.alignItems = isOutgoing == true ? .end : .start
        
        if let topTextNode = topTextNode {
            verticalSpec.setChild(topTextNode, at: 0)
        }
        
        if let contentTopFinal = contentTopFinal {
            verticalSpec.setChild(contentTopFinal, at: 1)
        }
        
        verticalSpec.setChild(horizontalSpec, at: 2)
        
        if let bottomTextNode = bottomTextNode {
            verticalSpec.setChild(bottomTextNode, at: 3)
        }
        
        let insets = UIEdgeInsetsMake(1, 4, 5, 4)
        let insetSpec = ASInsetLayoutSpec(insets: insets, child: verticalSpec)
        return insetSpec
    }
}

private extension Array {
    static func filterNils(_ array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
    
}
