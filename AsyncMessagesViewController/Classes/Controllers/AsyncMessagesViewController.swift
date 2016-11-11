//
//  AsyncMessagesViewController.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 12/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SlackTextViewController

open class AsyncMessagesViewController: SLKTextViewController {

    public let dataSource: AsyncMessagesCollectionViewDataSource?
    
    override open var collectionView: ASCollectionView {
        return scrollView as! ASCollectionView
    }
    
    open var collectionNode : ASCollectionNode

    public init(dataSource: AsyncMessagesCollectionViewDataSource) {
        self.dataSource = dataSource

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
       // let asyncCollectionView = ASCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionNode.backgroundColor = UIColor.white
        collectionNode.view.scrollsToTop = AsyncMessagesConfiguration.messageTranscriptScrollsToTop
        collectionNode.dataSource = dataSource
        super.init(scrollView: collectionNode.view)
        
        isInverted = AsyncMessagesConfiguration.invertScrollView
    }

    required public init(coder aDecoder: NSCoder) {
//      //  super.init()
//        dataSource = nil
//        
//        super.init(coder: aDecoder)
      fatalError("init(coder:) has not been implemented")
    }

    override open func viewWillLayoutSubviews() {
        let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, 5, 0)
    
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets

        super.viewWillLayoutSubviews()
    }
    
    public func scrollCollectionViewToBottom() {
        
        let numberOfItems = dataSource?.collectionNode?(collectionNode, numberOfItemsInSection: 0)
        
        if numberOfItems! > 0 {
            let lastItemIndexPath = IndexPath(item: numberOfItems! - 1, section: 0)
            collectionNode.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
        }
    }
    
    public func scrollCollectionViewToTop() {
        let numberOfItems = dataSource?.collectionNode?(collectionNode, numberOfItemsInSection: 0)
        if numberOfItems! > 0 {
            let firstItemIndexPath = IndexPath(item: 0, section: 0)
            collectionNode.scrollToItem(at: firstItemIndexPath, at: .top, animated: true)
        }
    }
    
//    override open func didPressLeftButton(_ sender: Any?) {
//        super.didPressLeftButton(sender)
//    }
//    
//
//    override open func didPressRightButton(_ sender: Any?) {
//        super.didPressRightButton(sender)
//
//    }
    
    
}
