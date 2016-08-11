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

public extension Bundle {
    public class func asyncBundle() -> Bundle {
        return Bundle(for: AsyncMessagesViewController.self)
    }
    
    
    public class func asyncAssetsBundle() -> Bundle {
        let path : NSString = Bundle.asyncBundle().resourcePath! as NSString
        let assetPath = path.appendingPathComponent(kBundleName)
        return Bundle(path: assetPath)!
    }
    
    public class func asyncImage(_ name: String, ofType: String) -> UIImage {
        let bund = Bundle.asyncAssetsBundle()
        let path = bund.path(forResource: name, ofType: ofType, inDirectory: "images")
        return UIImage(contentsOfFile: path!)!
    }
    
    public class func asyncLocalizedStringForKey(_ key: String) -> String {
        return NSLocalizedString(key, tableName: kTableName, bundle: Bundle.asyncAssetsBundle(), comment: "")
    }
}
