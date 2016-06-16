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

public let kAMMessageCellNodeTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]
public let kAMMessageCellNodeContentTopTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(12)]
public let kAMMessageCellNodeBottomTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
    NSFontAttributeName: UIFont.systemFontOfSize(11)]

public class MessageCellNode: ASCellNode {
    
    private let isOutgoing: Bool
    private let topTextNode: ASTextNode?
    private let contentTopTextNode: ASTextNode?
    private let bottomTextNode: ASTextNode?
    private let bubbleNode: ASDisplayNode
    private let avatarImageSize: CGFloat
    private let avatarImageNode: ASNetworkImageNode?

    init(isOutgoing: Bool, topText: NSAttributedString?, contentTopText: NSAttributedString?, bottomText: NSAttributedString?, senderAvatarURL: NSURL?, senderAvatarImageSize: CGFloat = kAMMessageCellNodeAvatarImageSize, bubbleNode: ASDisplayNode) {
        self.isOutgoing = isOutgoing

        topTextNode = topText != nil ? ASTextNode() : nil
        topTextNode?.layerBacked = true
        topTextNode?.attributedString = topText
        topTextNode?.alignSelf = .Center

        contentTopTextNode = contentTopText != nil ? ASTextNode() : nil
        contentTopTextNode?.layerBacked = true
        contentTopTextNode?.attributedString = contentTopText
        
        avatarImageSize = senderAvatarImageSize
        avatarImageNode = avatarImageSize > 0 ? ASNetworkImageNode() : nil
        avatarImageNode?.preferredFrameSize = CGSizeMake(avatarImageSize, avatarImageSize)
        avatarImageNode?.backgroundColor = UIColor.clearColor()
        // This line below causes a bug ... need to ask about it on Slack.
        //avatarImageNode?.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        avatarImageNode?.imageModificationBlock = { (image: UIImage) -> UIImage in
            let preferredSize = CGSizeMake(senderAvatarImageSize, senderAvatarImageSize)
            let newImage = image.makeCircularImageWithSize(preferredSize)
            return newImage
        }
        avatarImageNode?.URL = senderAvatarURL
        
        self.bubbleNode = bubbleNode
        self.bubbleNode.flexShrink = true
        
        bottomTextNode = bottomText != nil ? ASTextNode() : nil
        bottomTextNode?.layerBacked = true
        bottomTextNode?.attributedString = bottomText

        super.init()
        
        if let node = topTextNode { addSubnode(node) }
        if let node = contentTopTextNode { addSubnode(node) }
        if let node = avatarImageNode { addSubnode(node) }
        addSubnode(bubbleNode)
        if let node = bottomTextNode { addSubnode(node) }
        
        selectionStyle = .None
    }
    
    override public func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let contentTopFinal : ASLayoutSpec? = contentTopTextNode == nil ? nil : ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 22 + avatarImageSize, 0, 0), child: contentTopTextNode!)
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(1, 4, 1, 4),
            child: ASStackLayoutSpec(
                direction: .Vertical,
                spacing: 0,
                justifyContent: .Start, // Never used
                alignItems: isOutgoing == true ? .End : .Start,
                children: Array.filterNils([
                    topTextNode,
                    contentTopFinal,
                    ASStackLayoutSpec(
                        direction: .Horizontal,
                        spacing: 2,
                        justifyContent: .Start, // Never used
                        alignItems: .End,
                        children: Array.filterNils(isOutgoing == true ? [bubbleNode, self.avatarImageNode! ] : [self.avatarImageNode!, bubbleNode])),
                    bottomTextNode])))
    }
    
}

private extension Array {
    
    // Credits: http://stackoverflow.com/a/28190873/1136669
    static func filterNils(array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
    
}
