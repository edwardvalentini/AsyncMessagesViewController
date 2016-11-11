//
//  AsyncMessagesCollectionViewDataSource.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 26/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public protocol AsyncMessagesCollectionViewDataSource: ASCollectionDataSource {
    
    func currentUserID() -> String?
    

    
    func collectionNode(_ collectionNode: ASCollectionNode, updateCurrentUserID newUserID: String?)
    
    func collectionNode(_ collectionNode: ASCollectionNode, messageForItemAtIndexPath indexPath: IndexPath) -> MessageData
    
    func collectionNode(_ collectionNode: ASCollectionNode, insertMessages newMessages: [MessageData], completion: ((Bool) -> ())?)
    
    func collectionNode(_ collectionNode: ASCollectionNode, replaceMessages newMessages: [MessageData], completion: ((Bool) -> ())?)
    
    func collectionNode(_ collectionNode: ASCollectionNode, deleteMessagesAtIndexPaths indexPaths: [IndexPath], completion: ((Bool) -> ())?)
    
}
