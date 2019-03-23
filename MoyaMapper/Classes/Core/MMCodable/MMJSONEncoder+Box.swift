//
//  MMJSONEncoder+Box.swift
//  MoyaMapper
//
//  Created by LinXunFeng on 2019/3/19.
//  Copyright © 2019 LXF. All rights reserved.
//

import Foundation

// MARK: - Concrete Value Representations

extension _MMJSONEncoder {
    /// Returns the given value boxed in a container appropriate for pushing onto the container stack.
    func box(_ value: Bool)   -> NSObject { return NSNumber(value: value) }
    func box(_ value: Int)    -> NSObject { return NSNumber(value: value) }
    func box(_ value: Int8)   -> NSObject { return NSNumber(value: value) }
    func box(_ value: Int16)  -> NSObject { return NSNumber(value: value) }
    func box(_ value: Int32)  -> NSObject { return NSNumber(value: value) }
    func box(_ value: Int64)  -> NSObject { return NSNumber(value: value) }
    func box(_ value: UInt)   -> NSObject { return NSNumber(value: value) }
    func box(_ value: UInt8)  -> NSObject { return NSNumber(value: value) }
    func box(_ value: UInt16) -> NSObject { return NSNumber(value: value) }
    func box(_ value: UInt32) -> NSObject { return NSNumber(value: value) }
    func box(_ value: UInt64) -> NSObject { return NSNumber(value: value) }
    func box(_ value: String) -> NSObject { return NSString(string: value) }
    
    func box(_ float: Float) throws -> NSObject {
        guard !float.isInfinite && !float.isNaN else {
            guard case let .convertToString(positiveInfinity: posInfString,
                                            negativeInfinity: negInfString,
                                            nan: nanString) = self.options.nonConformingFloatEncodingStrategy else {
                                                throw EncodingError._invalidFloatingPointValue(float, at: codingPath)
            }
            
            if float == Float.infinity {
                return NSString(string: posInfString)
            } else if float == -Float.infinity {
                return NSString(string: negInfString)
            } else {
                return NSString(string: nanString)
            }
        }
        
        return NSNumber(value: float)
    }
    
    func box(_ double: Double) throws -> NSObject {
        guard !double.isInfinite && !double.isNaN else {
            guard case let .convertToString(positiveInfinity: posInfString,
                                            negativeInfinity: negInfString,
                                            nan: nanString) = self.options.nonConformingFloatEncodingStrategy else {
                                                throw EncodingError._invalidFloatingPointValue(double, at: codingPath)
            }
            
            if double == Double.infinity {
                return NSString(string: posInfString)
            } else if double == -Double.infinity {
                return NSString(string: negInfString)
            } else {
                return NSString(string: nanString)
            }
        }
        
        return NSNumber(value: double)
    }
    
    func box(_ date: Date) throws -> NSObject {
        switch self.options.dateEncodingStrategy {
        case .deferredToDate:
            // Must be called with a surrounding with(pushedKey:) call.
            // Dates encode as single-value objects; this can't both throw and push a container, so no need to catch the error.
            try date.encode(to: self)
            return self.storage.popContainer()
            
        case .secondsSince1970:
            return NSNumber(value: date.timeIntervalSince1970)
            
        case .millisecondsSince1970:
            return NSNumber(value: 1000.0 * date.timeIntervalSince1970)
            
        case .iso8601:
            if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                return NSString(string: _iso8601Formatter.string(from: date))
            } else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }
            
        case .formatted(let formatter):
            return NSString(string: formatter.string(from: date))
            
        case .custom(let closure):
            let depth = self.storage.count
            do {
                try closure(date, self)
            } catch {
                // If the value pushed a container before throwing, pop it back off to restore state.
                if self.storage.count > depth {
                    let _ = self.storage.popContainer()
                }
                
                throw error
            }
            
            guard self.storage.count > depth else {
                // The closure didn't encode anything. Return the default keyed container.
                return NSDictionary()
            }
            
            // We can pop because the closure encoded something.
            return self.storage.popContainer()
        }
    }
    
    func box(_ data: Data) throws -> NSObject {
        switch self.options.dataEncodingStrategy {
        case .deferredToData:
            // Must be called with a surrounding with(pushedKey:) call.
            let depth = self.storage.count
            do {
                try data.encode(to: self)
            } catch {
                // If the value pushed a container before throwing, pop it back off to restore state.
                // This shouldn't be possible for Data (which encodes as an array of bytes), but it can't hurt to catch a failure.
                if self.storage.count > depth {
                    let _ = self.storage.popContainer()
                }
                
                throw error
            }
            
            return self.storage.popContainer()
            
        case .base64:
            return NSString(string: data.base64EncodedString())
            
        case .custom(let closure):
            let depth = self.storage.count
            do {
                try closure(data, self)
            } catch {
                // If the value pushed a container before throwing, pop it back off to restore state.
                if self.storage.count > depth {
                    let _ = self.storage.popContainer()
                }
                
                throw error
            }
            
            guard self.storage.count > depth else {
                // The closure didn't encode anything. Return the default keyed container.
                return NSDictionary()
            }
            
            // We can pop because the closure encoded something.
            return self.storage.popContainer()
        }
    }
    
    func box<T : Encodable>(_ value: T) throws -> NSObject {
        return try self.box_(value) ?? NSDictionary()
    }
    
    // This method is called "box_" instead of "box" to disambiguate it from the overloads. Because the return type here is different from all of the "box" overloads (and is more general), any "box" calls in here would call back into "box" recursively instead of calling the appropriate overload, which is not what we want.
    func box_<T : Encodable>(_ value: T) throws -> NSObject? {
        if T.self == Date.self || T.self == NSDate.self {
            // Respect Date encoding strategy
            return try self.box((value as! Date))
        } else if T.self == Data.self || T.self == NSData.self {
            // Respect Data encoding strategy
            return try self.box((value as! Data))
        } else if T.self == URL.self || T.self == NSURL.self {
            // Encode URLs as single strings.
            return self.box((value as! URL).absoluteString)
        } else if T.self == Decimal.self || T.self == NSDecimalNumber.self {
            // JSONSerialization can natively handle NSDecimalNumber.
            return (value as! NSDecimalNumber)
        }
        
        // The value should request a container from the _JSONEncoder.
        let depth = self.storage.count
        do {
            try value.encode(to: self)
        } catch {
            // If the value pushed a container before throwing, pop it back off to restore state.
            if self.storage.count > depth {
                let _ = self.storage.popContainer()
            }
            
            throw error
        }
        
        // The top container should be a new container.
        guard self.storage.count > depth else {
            return nil
        }
        
        return self.storage.popContainer()
    }
}
