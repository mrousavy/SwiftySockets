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
    
    
    ///
    /// Reads a string from the connection.
    ///
    /// - Returns: The read string, or nil if none
    ///
    public func readString() throws -> String? {
        
    }
    
    ///
    /// Reads all available data into an Data object.
    ///
    /// - Parameter data: Data object to contain read data.
    ///
    /// - Returns: Integer representing the number of bytes read.
    ///
    public func read(into data: inout Data) throws -> Int {
        
    }
    
    ///
    /// Reads all available data into an NSMutableData object.
    ///
    /// - Parameter data: NSMutableData object to contain read data.
    ///
    /// - Returns: Integer representing the number of bytes read.
    ///
    public func read(into data: NSMutableData) throws -> Int {
        
    }
    
    
    
    ///
    /// Writes a string to the connection
    ///
    /// - Parameter string: String data to be written.
    ///
    /// - Throws: Throws when the write process could not
    /// be completed because of a connection error
    ///
    public func write(from string: String) throws -> Int {
        code
    }
    
    ///
    /// Writes data from Data object.
    ///
    /// - Parameter data: Data object containing the data to be written.
    ///
    public func write(from data: Data) throws -> Int {
        <#code#>
    }
    ///
    /// Writes data from NSData object.
    ///
    /// - Parameter data: NSData object containing the data to be written.
    ///
    public func write(from data: NSData) throws -> Int {
        <#code#>
    }
    
    
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
    public init(ip: IPAddress) {
        _ip = ip
    }
}
