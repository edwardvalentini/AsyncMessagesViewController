//
//  AsyncMessagesConfiguration.swift
//  Pods
//
//  Created by Edward Valentini on 6/22/16.
//
//

import Foundation

/*
 
 show tail on every message or only last
 show avatar on every message or only last
 show avatar at all
 show name on every message or only first in group
 show date on every message or only every 3
 color incoming font
 color outgoing font
 font name for text bubbles
 bubble color incoming
 bubble color outgoing
 avatar size
 
 number of screens in advance to load
 function to load new content spits out [MessageData]
 
 */

public class AsyncMessagesConfiguration {

    public static var messageTranscriptScrollsToTop : Bool = true
    public static var invertScrollView : Bool = false
    public static var defaultOutgoingTextBubbleColor : UIColor = UIColor(red: 17 / 255, green: 107 / 255, blue: 254 / 255, alpha: 1)
    public static var defaultOutgoingEnhancedBubbleColor : UIColor = UIColor(red: 17 / 255, green: 107 / 255, blue: 254 / 255, alpha: 1)
    public static var defaultIncomingTextBubbleColor : UIColor = UIColor(red: 239 / 255, green: 237 / 255, blue: 237 / 255, alpha: 1)
    public static var defaultIncomingEnhancedBubbleColor : UIColor = UIColor(red: 239 / 255, green: 237 / 255, blue: 237 / 255, alpha: 1)
    public static var defaultIncomingTextFontColor : UIColor = UIColor.blackColor()
    public static var defaultOutgoingTextFontColor : UIColor = UIColor.whiteColor()
    public static var defaultTextSize : CGFloat = 14.0
    
}