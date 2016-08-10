//
//  UIImage+AsyncMessagesViewController.swift
//  Pods
//
//  Created by Edward Valentini on 6/16/16.
//
//

import UIKit
import Foundation

extension UIImage {
    func makeCircularImageWithSize(size: CGSize) -> UIImage {
        let circleRect = CGRectMake(0.0, 0.0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0.0)
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width/2.0)
        circle.addClip()
        self.drawInRect(circleRect)
        circle.lineWidth = 1
        UIColor.darkGrayColor().set()
        circle.stroke()
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }
    
    func imageMaskedWith(color: UIColor) -> UIImage {
        let imageRect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -(imageRect.size.height))
        
        CGContextClipToMask(context, imageRect, CGImage)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
