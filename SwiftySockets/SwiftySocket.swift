//
//  SwiftySocket.swift
//  SwiftySockets
//
//  Created by Marc Rousavy on 30/08/2017.
//  Copyright © 2017 mrousavy. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Darwin //NEEDED ON MACOS
#elseif os(Linux)
    import Glibc //NEEDED ON LINUX
#endif

import Foundation


///
/// The swifty socket class
///
public class SwiftySocket : NetReader, NetWriter {
    
    
    
    /// Properties
    private var _ip: IPAddress
    public var IP: IPAddress {
        get {
            return _ip
        }
    }
    
    ///
    /// Create a new instance of the Swifty Socket class
    ///
    /// - Parameter ip: The IP Address to host this socket on
    ///
    init(ip: IPAddress) {
        _ip = ip
    }
}
