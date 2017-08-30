//
//  IPAddress.swift
//  SwiftySockets
//
//  Created by Marc Rousavy on 30/08/2017.
//  Copyright © 2017 mrousavy. All rights reserved.
//

import Foundation


enum InvalidIPAddressError: Error {
    case IPOutOfBounds(ip: String)
}

/**
 A valid IPAddress
 */
struct IPAddress {
    // Properties
    private var _ip: String
    public var IP: String {
        get {
            return _ip
        }
    }
    
    /**
     Create a new instance of the Swifty Socket class
     
     @param ip The IP Address to host this socket on
     */
    init(ip: String) {
        if(validate(ip: ip)) {
            _ip = ip
        } else {
            throw InvalidIPAddressError.IPOutOfBounds(ip: ip)
        }
    }
    
    func validate(ip: String) -> Bool {
        let parts = s.componentsSeparatedByString(".")
        let nums = parts.flatMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
}
