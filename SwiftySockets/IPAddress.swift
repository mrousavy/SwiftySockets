//
//  IPAddress.swift
//  SwiftySockets
//
//  Created by Marc Rousavy on 30/08/2017.
//  Copyright © 2017 mrousavy. All rights reserved.
//

import Foundation

///
/// A invalid IP Address error
///
/// - IPOutOfBounds: The IP Address was out of bounds of valid IP Addresses (0-255.0-255.0-255.0-255)
/// */
public enum InvalidIPAddressError: Error {
    case IPOutOfBounds(ip: String)
}

/// 
/// The Internet Protocol (IP) Address Family
///
public enum AddressFamily {
    case IPv4
    case IPv6
}

///
/// A valid IPAddress
///
public struct IPAddress : CustomStringConvertible {
    // Properties
    private var _ip: String
    public var IP: String {
        get {
            return _ip
        }
    }
    
    public var description: String {
        return IP
    }
    
    public func toString() -> String {
        return IP
    }
    
    ///
    /// Create a new instance of the Swifty Socket class
    ///
    /// - parameter ip: The IP Address to host this socket on
    ///
    /// - throws: When the IP Address is not valid
    ///
    public init(ip: String, family: AddressFamily) throws {
        _ip = ip
        if(family == AddressFamily.IPv4){
            if(!validateIPv4(ip: ip)) {
                throw InvalidIPAddressError.IPOutOfBounds(ip: ip)
            }
        }else{
            if(!validateIPv6(ip: ip)) {
                throw InvalidIPAddressError.IPOutOfBounds(ip: ip)
            }
        }
    }
    
    ///
    /// Validate a given IPv4 Address
    ///
    /// - Parameter ip: The IP Address to validate
    ///
    /// - returns: True if the IP Address is valid
    ///
    private func validateIPv4(ip: String) -> Bool {
        let parts = ip.components(separatedBy: ".")
        let nums = parts.flatMap { Int($0) }
        let isValid = parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
        return isValid
    }
    
    ///
    /// Validate a given IPv6 Address
    ///
    /// - Parameter ip: The IP Address to validate
    ///
    /// - returns: True if the IP Address is valid
    ///
    private func validateIPv6(ip: String) -> Bool {
        //TODO: validate IPv6 address (RegEx?)
        //let parts = ip.components(separatedBy: ":")
        let isValid = true
        return isValid
    }
}
