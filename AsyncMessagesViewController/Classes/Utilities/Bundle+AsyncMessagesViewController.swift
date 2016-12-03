//
//  Bundle+AsyncMessagesViewController.swift
//  Pods
//
//  Created by Edward Valentini on 6/16/16.
//
//


import Foundation

let kBundleName = "AsyncMessagesViewController.bundle"
let kTableName = "AsyncMessagesViewController"

public extension Bundle {
    
    public class func asyncBundle() -> Bundle? {
        let bundle = Bundle(for: AsyncMessagesViewController.self)
        guard let pathOfBund = bundle.resourceURL else {
            return nil
        }
        
        let bundleURL = pathOfBund.appendingPathComponent(kBundleName)
        guard let frameworkBundle = Bundle(url: bundleURL) else {
            return nil
        }
        
        return frameworkBundle
    }
    
    public class func asyncLocalizedStringForKey(_ key: String) -> String? {
        guard let cab = Bundle.asyncBundle() else {
            return nil
        }
        return NSLocalizedString(key, tableName: kTableName, bundle: cab, comment: "")
    }
    
    public class func asyncImage(withName name: String, andExtension ext: String) -> UIImage? {
        guard let cab = Bundle.asyncBundle() else {
            return nil
        }
        
        guard let imagePath = cab.path(forResource: name, ofType: ext, inDirectory: "images") else {
            return nil
        }
        
        guard let image = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        
        return image
    }

}
