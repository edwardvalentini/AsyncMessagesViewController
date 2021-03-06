//
//  DefaultAsyncMessagesCollectionViewDataSource.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

//TODO: Make AsyncMessagesCollectionViewDataSource's methods thread-safe.
public class DefaultAsyncMessagesCollectionViewDataSource: NSObject, AsyncMessagesCollectionViewDataSource {
    
    private let nodeMetadataFactory: MessageCellNodeMetadataFactory
    private let bubbleImageProvider: MessageBubbleImageProvider
    private let timestampFormatter: MessageTimestampFormatter
    private let bubbleNodeFactories: [String: MessageBubbleNodeFactory]
    private var _currentUserID: String?
    /// Managed messages. They are sorted in ascending order of their date. The order is enforced during insertion.
    private var messages: [MessageData]
    private var nodeMetadatas: [MessageCellNodeMetadata]
    
    public init(currentUserID: String? = nil,
        nodeMetadataFactory: MessageCellNodeMetadataFactory = MessageCellNodeMetadataFactory(),
        bubbleImageProvider: MessageBubbleImageProvider = MessageBubbleImageProvider(),
        timestampFormatter: MessageTimestampFormatter = MessageTimestampFormatter(),
        bubbleNodeFactories: [String: MessageBubbleNodeFactory] = [
        ContentTypeSerializer.serialize(MessageDataContentType.text) : MessageTextBubbleNodeFactory(),
            ContentTypeSerializer.serialize(MessageDataContentType.networkImage) : MessageNetworkImageBubbleNodeFactory()
        ]) {
            _currentUserID = currentUserID
            self.nodeMetadataFactory = nodeMetadataFactory
            self.bubbleImageProvider = bubbleImageProvider
            self.timestampFormatter = timestampFormatter
            self.bubbleNodeFactories = bubbleNodeFactories
            messages = []
            nodeMetadatas = []
    }

    //MARK: ASCollectionViewDataSource methods

    public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        assert(nodeMetadatas.count == messages.count, "Node metadata is required for each message.")
        return messages.count
    }

    public func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        
        let message = self.collectionNode(collectionNode, messageForItemAtIndexPath: indexPath)
        let metadata = nodeMetadatas[(indexPath as NSIndexPath).item]
        let isOutgoing = metadata.isOutgoing

        let senderAvatarURL: URL? = metadata.showsSenderAvatar ? message.senderAvatarURL() as URL : nil
        let messageDate: NSAttributedString? = metadata.showsDate
            ? timestampFormatter.attributedTimestamp(message.date())
            : nil
        let senderDisplayName: NSAttributedString? = metadata.showsSenderName
            ? NSAttributedString(string: message.senderDisplayName(), attributes: kAMMessageCellNodeContentTopTextAttributes)
            : nil
        
        let bubbleImage = bubbleImageProvider.bubbleImage(isOutgoing, hasTail: metadata.showsTailForBubbleImage)
        assert(bubbleNodeFactories.index(forKey: message.contentType()) != nil, "No bubble node factory for content type: \(message.contentType())")
        let bubbleNode = bubbleNodeFactories[message.contentType()]!.build(message, isOutgoing: isOutgoing, bubbleImage: bubbleImage)
        
        let cellNode = MessageCellNode(
            isOutgoing: isOutgoing,
            topText: messageDate,
            contentTopText: senderDisplayName,
            bottomText: nil,
            senderAvatarURL: senderAvatarURL,
            bubbleNode: bubbleNode)
        
        return cellNode
    }
  
    public func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        
        let width = collectionNode.bounds.width;
        // Assume horizontal scroll directions
        return ASSizeRangeMake(CGSize(width: width, height: 0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }

    //MARK: AsyncMessagesCollectionViewDataSource methods
    public func currentUserID() -> String? {
        return _currentUserID
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, updateCurrentUserID newUserID: String?) {
        if newUserID == _currentUserID {
            return
        }
        
        _currentUserID = newUserID
        
        let outdatedMetadatas = nodeMetadatas
        let updatedMetadatas = nodeMetadataFactory.buildMetadatas(messages, currentUserID: _currentUserID)
        nodeMetadatas = updatedMetadatas
        
        let reloadIndicies = Array<MessageCellNodeMetadata>.computeDiff(outdatedMetadatas, rhs: updatedMetadatas)
        collectionNode.reloadItems(at: IndexPath.createIndexPaths(0, items: reloadIndicies))
    }

    public func collectionNode(_ collectionNode: ASCollectionNode, messageForItemAtIndexPath indexPath: IndexPath) -> MessageData {
        return messages[(indexPath as NSIndexPath).item]
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, replaceMessages newMessages: [MessageData], completion: ((Bool) -> ())?) {
        // fill in later. work in progress.
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, insertMessages newMessages: [MessageData], completion: ((Bool) -> ())?) {
        
        if newMessages.isEmpty {
            return
        }
        
        var insertedIndices = [Int]()
        // Sort new messages to make sure insertion starts from the begining of the array and previous insertion indicies are always valid.
        let isOrderedBefore: (MessageData, MessageData) -> Bool = {
            $0.date().compare($1.date() as Date) == ComparisonResult.orderedAscending
        }
        for newMessage in newMessages.sorted(by: isOrderedBefore) {
            insertedIndices.append(messages.insert(newMessage, isOrderedBefore: isOrderedBefore))
        }
        
        var outdatedNodeMetadatas = nodeMetadatas
        let updatedNodeMetadatas = nodeMetadataFactory.buildMetadatas(messages, currentUserID: _currentUserID)
        nodeMetadatas = updatedNodeMetadatas

        // Copy metadata of new messages to the outdated metadata array. Thus outdated and updated arrays will have the same size and computing diff between them will be much easier.
        for insertedIndex in insertedIndices {
            outdatedNodeMetadatas.insert(updatedNodeMetadatas[insertedIndex], at: insertedIndex)
        }
        let reloadIndicies = Array<MessageCellNodeMetadata>.computeDiff(outdatedNodeMetadatas, rhs: updatedNodeMetadatas)
        
        collectionNode.performBatchUpdates(
            {
                collectionNode.insertItems(at: IndexPath.createIndexPaths(0, items: insertedIndices))
                if !reloadIndicies.isEmpty {
                    collectionNode.reloadItems(at: IndexPath.createIndexPaths(0, items: reloadIndicies))
                }
            },
            completion: completion)
    }
  
  
    public func collectionNode(_ collectionNode: ASCollectionNode, deleteMessagesAtIndexPaths indexPaths: [IndexPath], completion: ((Bool) -> ())?) {
        if indexPaths.isEmpty {
            return
        }

        var outdatedNodesMetadata = nodeMetadatas
        // Sort indicies in descending order to make sure deletion starts from the end of the array and remaining indicies are always valid.
        let isOrderedBefore: (IndexPath, IndexPath) -> Bool = {
            ($0 as NSIndexPath).compare($1) == ComparisonResult.orderedDescending
        }
        let sortedIndexPaths = indexPaths.sorted(by: isOrderedBefore)
        for indexPath in sortedIndexPaths {
            messages.remove(at: (indexPath as NSIndexPath).item)
            outdatedNodesMetadata.remove(at: (indexPath as NSIndexPath).item)
        }

        let updatedNodeMetadatas = nodeMetadataFactory.buildMetadatas(messages, currentUserID: _currentUserID)
        nodeMetadatas = updatedNodeMetadatas

        let reloadIndicies = Array<MessageCellNodeMetadata>.computeDiff(outdatedNodesMetadata, rhs: updatedNodeMetadatas)
        
        collectionNode.performBatchUpdates(
            {
                collectionNode.deleteItems(at: sortedIndexPaths)
                if !reloadIndicies.isEmpty {
                    collectionNode.reloadItems(at: IndexPath.createIndexPaths(0, items: reloadIndicies))
                }
            },
            completion: completion)
    }
    
}

//MARK: Utils
private extension Array {

    mutating func insert(_ newElement: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        let index = insertionIndex(newElement, isOrderedBefore: isOrderedBefore)
        insert(newElement, at: index)
        return index
    }
    
    func insertionIndex(_ newElement: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = count - 1
        
        while (low <= high) {
            let mid = low + ((high - low) / 2)
            let midElement = self[mid]
            
            if isOrderedBefore(midElement, newElement) {
                low = mid + 1
            } else if isOrderedBefore(newElement, midElement) {
                high = mid - 1
            } else {
                return mid
            }
        }
        return low
    }
    
    static func computeDiff<T>(_ lhs: Array<T>, rhs: Array<T>) -> [Int] where T: Equatable {
        assert(lhs.count == rhs.count, "Expect arrays with the same size.")
        var diffIndices = [Int]()
        for i in 0..<lhs.count {
            if lhs[i] != rhs[i] {
                diffIndices.append(i)
            }
        }
        return diffIndices
    }
    
}

private extension IndexPath {
    
    static func createIndexPaths(_ section: Int, items: [Int]) -> [IndexPath] {
        return items.map() {
            IndexPath(item: $0, section: section)
        }
    }
    
}
