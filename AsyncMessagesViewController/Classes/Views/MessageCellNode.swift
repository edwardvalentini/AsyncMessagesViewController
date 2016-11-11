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
        topTextNode?.attributedString = topText
        topTextNode?.alignSelf = .center

        contentTopTextNode = contentTopText != nil ? ASTextNode() : nil
        contentTopTextNode?.isLayerBacked = true
        contentTopTextNode?.attributedString = contentTopText
        
        avatarImageSize = senderAvatarImageSize
        avatarImageNode = avatarImageSize > 0 ? ASNetworkImageNode() : nil
        avatarImageNode?.preferredFrameSize = CGSize(width: avatarImageSize, height: avatarImageSize)
        avatarImageNode?.backgroundColor = UIColor.clear
        // This line below causes a bug ... need to ask about it on Slack.
        //avatarImageNode?.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil)
        avatarImageNode?.imageModificationBlock = { (image: UIImage) -> UIImage in
            let preferredSize = CGSize(width: senderAvatarImageSize, height: senderAvatarImageSize)
            let newImage = image.makeCircularImageWithSize(preferredSize)
            return newImage
        }
        avatarImageNode?.url = senderAvatarURL
        
        self.bubbleNode = bubbleNode
        self.bubbleNode.flexShrink = 1.0
        
        bottomTextNode = bottomText != nil ? ASTextNode() : nil
        bottomTextNode?.isLayerBacked = true
        bottomTextNode?.attributedString = bottomText

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
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(1, 4, 5, 4),
            child: ASStackLayoutSpec(
                direction: .vertical,
                spacing: 0,
                justifyContent: .start, // Never used
                alignItems: isOutgoing == true ? .end : .start,
                children: Array.filterNils([
                    topTextNode,
                    contentTopFinal,
                    ASStackLayoutSpec(
                        direction: .horizontal,
                        spacing: 2,
                        justifyContent: .start, // Never used
                        alignItems: .end,
                        children: Array.filterNils(isOutgoing == true ? [bubbleNode, self.avatarImageNode! ] : [self.avatarImageNode!, bubbleNode])),
                    bottomTextNode])))
    }
    
}

private extension Array {
    
    // Credits: http://stackoverflow.com/a/28190873/1136669
    static func filterNils(_ array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
    
}
