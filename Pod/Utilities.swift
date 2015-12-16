//
//  Utilities.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/10/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Alamofire

/// Facilitate generics that Swift doesn't directly allow.
public struct Of<T> {
    /// Callback taking a `Result` with the given type as the success type and `API.Error` as the error type.
    public typealias callback = (Result<T, API.Error>) -> (Void)  // TODO: make error more generic?
}

// Dictionary concatenation operator
func +=<K, V> (inout left: [K: V], right: [K: V]) { for (k, v) in right { left[k] = v } }

// MARK: - throw-unwrapping

enum UnwrapError: ErrorType {
    case Nil
}

/**
 Unwrap an optional, throwing on `nil`
 
 - parameter value: The optional to unwrap
 
 - throws: `UnwrapError.Nil` when the optional is `nil`
 
 - returns: The unwrapped optional
 */
public func unwrapAndThrowOnNil<T>(value: T?) throws -> T {
    guard let value = value else {
        throw UnwrapError.Nil
    }
    return value
}
prefix operator ¿ {}
public prefix func ¿<T>(value: T?) throws -> T {
    return try unwrapAndThrowOnNil(value)
}

// MARK: NSDate <-> String conversion

private let dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter
}()

extension NSDate {
    func dateString() -> String {
        return dateFormatter.stringFromDate(self)
    }
    
    class func dateFromString(dateString: String) -> NSDate? {
        return dateFormatter.dateFromString(dateString)
    }
}
