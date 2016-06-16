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

public class AsyncMessagesViewController: SLKTextViewController {

    public let dataSource: AsyncMessagesCollectionViewDataSource?
    
    override public var collectionView: ASCollectionView {
        return scrollView as! ASCollectionView
    }

    public init(dataSource: AsyncMessagesCollectionViewDataSource) {
        self.dataSource = dataSource

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        //TODO: consider enabling asyncDataFetching
       // let asyncCollectionView = ASCollectionView(frame: CGRectZero, collectionViewLayout: layout, asyncDataFetching: false)
        
        let asyncCollectionView = ASCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        asyncCollectionView.backgroundColor = UIColor.whiteColor()
        asyncCollectionView.scrollsToTop = true
        asyncCollectionView.asyncDataSource = dataSource
        
        super.init(scrollView: asyncCollectionView)
        
        inverted = false
    }

    required public init(coder aDecoder: NSCoder) {
      //  super.init()
        dataSource = nil
        super.init(coder: aDecoder)
      //fatalError("init(coder:) has not been implemented")
    }

    override public func viewWillLayoutSubviews() {
        let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, 5, 0)
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets

        super.viewWillLayoutSubviews()
    }
    
    public func scrollCollectionViewToBottom() {
        
        let numberOfItems = dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)
        if numberOfItems! > 0 {
            let lastItemIndexPath = NSIndexPath(forItem: numberOfItems! - 1, inSection: 0)
            collectionView.scrollToItemAtIndexPath(lastItemIndexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
    
}