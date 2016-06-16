//
//  NSBundle+AsyncMessagesViewController.swift
//  Pods
//
//  Created by Edward Valentini on 6/16/16.
//
//


import Foundation

let kBundleName = "AsyncMessagesViewController.bundle"
let kTableName = "AsyncMessagesViewController"

public extension NSBundle {
    public class func asyncBundle() -> NSBundle {
        return NSBundle(forClass: AsyncMessagesViewController.self)
    }
    
    
    public class func asyncAssetsBundle() -> NSBundle {
        let path : NSString = NSBundle.asyncBundle().resourcePath! as NSString
        let assetPath = path.stringByAppendingPathComponent(kBundleName)
        return NSBundle(path: assetPath)!
    }
    
    public class func asyncImage(name: String, ofType: String) -> UIImage {
        let bund = NSBundle.asyncAssetsBundle()
        let path = bund.pathForResource(name, ofType: ofType, inDirectory: "images")
        return UIImage(contentsOfFile: path!)!
    }
    
    public class func asyncLocalizedStringForKey(key: String) -> String {
        return NSLocalizedString(key, tableName: kTableName, bundle: NSBundle.asyncAssetsBundle(), comment: "")
    }
}
