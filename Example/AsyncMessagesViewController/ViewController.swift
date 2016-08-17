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
        let avatarImageSize = CGSize(width: kAMMessageCellNodeAvatarImageSize, height: kAMMessageCellNodeAvatarImageSize)
        users = (0..<5).map() {
            let avatarURL = LoremIpsum.urlForPlaceholderImage(from: .loremPixel, with: avatarImageSize)
            return User(ID: "user-\($0)", name: LoremIpsum.name(), avatarURL: avatarURL!)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change user", style: .plain, target: self, action: #selector(ViewController.changeCurrentUser))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generateMessages()
    }
    
    override func didPressRightButton(_ sender: Any?) {
        if let user = currentUser {
            let message = Message(
                serializedContentType: ContentTypeSerializer.serialize(MessageDataContentType.text),
                content: textView.text,
                date: Date(),
                sender: user)
            dataSource!.collectionView(collectionView, insertMessages: [message]) {completed in
                self.scrollCollectionViewToBottom()
            }
        }
        super.didPressRightButton(sender)
    }
    
    private func random() -> Int {
        return Int(arc4random())
    }

    private func generateMessages() {
        var messages = [Message]()
        for i in 0..<1 {
            let isTextMessage = arc4random_uniform(4) <= 2 // 75%
            //let isTextMessage = true // arc4random_uniform(4) <= 2 // 75%
            let contentType = isTextMessage ? ContentTypeSerializer.serialize(MessageDataContentType.text) : ContentTypeSerializer.serialize(MessageDataContentType.networkImage)
            
            
            //let contentType = kAMMessageDataContentTypeText
            let content = isTextMessage
                ? LoremIpsum.words(withNumber: (random() % 100) + 1)
                : LoremIpsum.urlForPlaceholderImage(from: .loremPixel, with: CGSize(width: 200, height: 200)).absoluteString

            
     //       let content =  LoremIpsum.wordsWithNumber((random() % 100) + 1)
            
            
            
            let sender = users[random() % users.count]
            
            let previousMessage: Message? = i > 0 ? messages[i - 1] : nil
            let hasSameSender = (sender.ID == previousMessage?.senderID())
            let date = hasSameSender ? previousMessage!.date().addingTimeInterval(5) : LoremIpsum.date()
            
            let message = Message(
                serializedContentType: contentType,
                content: content!,
                date: date!,
                sender: sender)
            messages.append(message)
        }
//        dataSource!.collectionView(collectionView, insertMessages: messages, completion: nil)
        dataSource?.collectionView(collectionView, insertMessages: messages, completion: { [unowned self] (_) in
            self.scrollCollectionViewToBottom()
        })
    }
    
    func changeCurrentUser() {
        let otherUsers = users.filter({$0.ID != self.dataSource!.currentUserID()})
        let newUser = otherUsers[random() % otherUsers.count]
        dataSource!.collectionView(collectionView, updateCurrentUserID: newUser.ID)
    }

}

