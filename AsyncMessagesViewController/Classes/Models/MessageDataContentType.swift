//
//  MessageDataContentType.swift
//  Pods
//
//  Created by Edward Valentini on 7/7/16.
//
//

import Foundation

//public let kAMMessageDataContentTypeText: MessageDataContentType = 0
//public let kAMMessageDataContentTypeNetworkImage: MessageDataContentType = 1

public final class MessageDataContentType: ExtensibleEnum, CustomStringConvertible {
    public let description: String
    
    public init(description: String) {
        self.description = description
    }
}

extension MessageDataContentType {
    public static let text = MessageDataContentType(description: "text")
    public static let networkImage = MessageDataContentType(description: "networkImage")
}

@objc public class ContentTypeSerializer : NSObject {
    
    public class func serialize(contentType: MessageDataContentType) -> String {
        return contentType.description
    }
}