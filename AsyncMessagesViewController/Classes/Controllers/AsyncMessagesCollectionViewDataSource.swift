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
    
    func collectionView(_ collectionView: ASCollectionView, updateCurrentUserID newUserID: String?)
    
    func collectionView(_ collectionView: ASCollectionView, messageForItemAtIndexPath indexPath: IndexPath) -> MessageData
    
    func collectionView(_ collectionView: ASCollectionView, insertMessages newMessages: [MessageData], completion: ((Bool) -> ())?)
    
    func collectionView(_ collectionView: ASCollectionView, replaceMessages newMessages: [MessageData], completion: ((Bool) -> ())?)
    
    func collectionView(_ collectionView: ASCollectionView, deleteMessagesAtIndexPaths indexPaths: [IndexPath], completion: ((Bool) -> ())?)
    
}
