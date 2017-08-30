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

public class SocketError : Error {
    public var code: Int
    
    public init(code: Int) {
        self.code = code
    }
}

///
/// The swifty socket class
///
public class SwiftySocket : NetReader, NetWriter {
    /// CONSTANTS
    public static let DEF_READ_BUFFER_SIZE: Int = 1024
    public static let DEF_WRITE_BUFFER_SIZE: Int = 1024
    
    
    /// ERROR CODES
    public static let ERR_INVALID_BUFFER: Int = 0
    public static let ERR_BUFFER_TOO_SMALL: Int = 1
    public static let ERR_NOT_CONNECTED: Int = 2
    
    /// Properties
    private var _ip: IPAddress
    private var _isConnected: Bool
    private var _cache: NSMutableData
    public var IP: IPAddress {
        return _ip
    }
    public var isConnected: Bool {
        return _isConnected
    }
    public var cache: NSMutableData {
        return _cache
    }
    
    ///
    /// Create a new instance of the Swifty Socket class
    ///
    /// - Parameter ip: The IP Address to host this socket on
    ///
    public init(ip: IPAddress) {
        _ip = ip
        _isConnected = false
        _cache = NSMutableData(capacity: SwiftySocket.DEF_READ_BUFFER_SIZE)!
    }
    
    
    ///
    /// Read data from the socket.
    ///
    /// - Parameters:
    ///		- buffer: The buffer to return the data in.
    /// 	- bufSize: The size of the buffer.
    ///		- truncate: Whether the data should be truncated if there is more available data than could fit in `buffer`.
    ///			**Note:** If called with `truncate = true` unretrieved data will be returned on next `read` call.
    ///
    /// - Throws: `Socket.SOCKET_ERR_RECV_BUFFER_TOO_SMALL` if the buffer provided is too small and `truncate = false`.
    ///		Call again with proper buffer size (see `Error.bufferSizeNeeded`) or
    ///		use `readData(data: NSMutableData)`.
    ///
    /// - Returns: The number of bytes read.
    ///
    public func read(into buffer: UnsafeMutablePointer<CChar>, bufSize: Int, truncate: Bool = false) throws -> Int {
        
        // Is buffer valid?
        if bufSize < 1 {
            throw SocketError(code: SwiftySocket.ERR_INVALID_BUFFER)
        }
        
        /// CACHED OPERATION
        
        // Check if any bytes are cached/buffered already
        if cache.length > 0 {
            // Check if bufSize is big enough
            if bufSize < self.cache.length {
                // If truncate we can copy over with remainders, else that's an error
                if truncate {
                    //TODO: MEMMOVE OR MEMCOPY?
                    
                    // Move the bytes from the cache to the buffer
                    memmove(buffer, self.cache.bytes, bufSize)
                    
/*
                    // Copy the cached buffer over into the param buffer
                    memcpy(buffer, self.cache.bytes, bufSize)
                    // Clear the copied bytes
                    self.cache.replaceBytes(in: NSRange(location:0, length:bufSize), withBytes: nil, length: 0)
 */
                    return bufSize
                    
                } else {
                    throw SocketError(code: SwiftySocket.ERR_BUFFER_TOO_SMALL)
                }
            } else {
                // Local var because cache changes after move
                let cacheSize = self.cache.length
                
                // Move over whole cache
                memmove(buffer, self.cache.bytes, cacheSize)
                
                return cacheSize
            }

        }
        
        /// ACTUAL DOWNLOAD
        
        // For reading, the socket has to be connected
        if !self.isConnected {
            throw SocketError(code: SwiftySocket.ERR_NOT_CONNECTED)
        }    }
    
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
        // TODO
    }
    
    ///
    /// Writes data from Data object.
    ///
    /// - Parameter data: Data object containing the data to be written.
    ///
    public func write(from data: Data) throws -> Int {
        // TODO
    }
    ///
    /// Writes data from NSData object.
    ///
    /// - Parameter data: NSData object containing the data to be written.
    ///
    public func write(from data: NSData) throws -> Int {
        // TODO
    }
    
}
