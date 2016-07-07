//
//  ExtensibleEnum.swift
//  Pods
//
//  Created by Edward Valentini on 7/7/16.
//
//

import Foundation

public protocol ExtensibleEnum: class, Hashable {}

extension ExtensibleEnum {
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

public func ==<T: ExtensibleEnum>(lhs: T, rhs: T) -> Bool {
    return lhs === rhs
}