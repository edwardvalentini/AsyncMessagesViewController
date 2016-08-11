//
//  MessageTimestampFormatter.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 14/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

public class MessageTimestampFormatter {
    
    private let dateFormatter: DateFormatter
    private let dateTextAttributes: [String: AnyObject]
    private let timeTextAttributes: [String: AnyObject]
    
    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.doesRelativeDateFormatting = true

        let color = UIColor.lightGray

        dateTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: color
        ]
        
        timeTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12),
            NSForegroundColorAttributeName: color
        ]
    }

    public func attributedTimestamp(_ date: Date) -> NSAttributedString {
        let relativeDate = relativeDateString(date)
        let time = timeString(date)
        let timestamp = NSMutableAttributedString(string: relativeDate, attributes: dateTextAttributes)
        timestamp.append(NSAttributedString(string: " "))
        timestamp.append(NSAttributedString(string: time, attributes: timeTextAttributes))
        return timestamp
    }
    
    private func timeString(_ date: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    private func relativeDateString(_ date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
}
