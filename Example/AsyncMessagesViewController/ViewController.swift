//
//  ViewController.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import AsyncMessagesViewController
import LoremIpsum

class ViewController: AsyncMessagesViewController, ASCollectionDelegate {

    private let users: [User]
    private var currentUser: User? {
        return users.filter({$0.ID == self.dataSource!.currentUserID()}).first
    }
    
    init() {
        // Assume the default image size is used for message cell nodes
        let avatarImageSize = CGSizeMake(kAMMessageCellNodeAvatarImageSize, kAMMessageCellNodeAvatarImageSize)
        users = (0..<5).map() {
            let avatarURL = LoremIpsum.URLForPlaceholderImageFromService(.LoremPixel, withSize: avatarImageSize)
            return User(ID: "user-\($0)", name: LoremIpsum.name(), avatarURL: avatarURL)
        }
        
        let dataSource = DefaultAsyncMessagesCollectionViewDataSource(currentUserID: users[0].ID)
        super.init(dataSource: dataSource)
      
        collectionView.asyncDelegate = self
    }
    
    deinit {
        // Tell ASCollectionView that this object is being deallocated (Issue #4)
        collectionView.asyncDelegate = nil
    }
    
    required init(coder aDecoder: NSCoder) {
        users = []
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change user", style: .Plain, target: self, action: #selector(ViewController.changeCurrentUser))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        generateMessages()
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        if let user = currentUser {
            let message = Message(
                contentType: kAMMessageDataContentTypeText,
                content: textView.text,
                date: NSDate(),
                sender: user)
            dataSource!.collectionView(collectionView, insertMessages: [message]) {completed in
                self.scrollCollectionViewToBottom()
            }
        }
        super.didPressRightButton(sender)
    }

    private func generateMessages() {
        var messages = [Message]()
        for i in 0..<200 {
            let isTextMessage = arc4random_uniform(4) <= 2 // 75%
            //let isTextMessage = true // arc4random_uniform(4) <= 2 // 75%
            let contentType = isTextMessage ? kAMMessageDataContentTypeText : kAMMessageDataContentTypeNetworkImage
            
            //let contentType = kAMMessageDataContentTypeText
            let content = isTextMessage
                ? LoremIpsum.wordsWithNumber((random() % 100) + 1)
                : LoremIpsum.URLForPlaceholderImageFromService(.LoremPixel, withSize: CGSizeMake(200, 200)).absoluteString

            
     //       let content =  LoremIpsum.wordsWithNumber((random() % 100) + 1)
            
            
            
            let sender = users[random() % users.count]
            
            let previousMessage: Message? = i > 0 ? messages[i - 1] : nil
            let hasSameSender = (sender.ID == previousMessage?.senderID()) ?? false
            let date = hasSameSender ? previousMessage!.date().dateByAddingTimeInterval(5) : LoremIpsum.date()
            
            let message = Message(
                contentType: contentType,
                content: content,
                date: date,
                sender: sender)
            messages.append(message)
        }
        dataSource!.collectionView(collectionView, insertMessages: messages, completion: nil)
    }
    
    func changeCurrentUser() {
        let otherUsers = users.filter({$0.ID != self.dataSource!.currentUserID()})
        let newUser = otherUsers[random() % otherUsers.count]
        dataSource!.collectionView(collectionView, updateCurrentUserID: newUser.ID)
    }

}

