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
    public static let DEF_READ_BUFFER_SIZE: 		Int = 1024
    public static let DEF_WRITE_BUFFER_SIZE: 		Int = 1024
    public static let DEF_SSL_READ_BUFFER_SIZE: 	Int = 1024
	public static let DEF_SSL_WRITE_BUFFER_SIZE: 	Int = 1024
	public static let SOCKET_INVALID_DESCRIPTOR: 	Int32 = -1
	
    
    /// ERROR CODES
    public static let ERR_INVALID_BUFFER: Int = 0
    public static let ERR_BUFFER_TOO_SMALL: Int = 1
    public static let ERR_NOT_CONNECTED: Int = 2
    
    /// Properties
    private var _ip: IPAddress
    private var _isConnected: Bool
    private var _cache: NSMutableData
	private var _readBuffer: UnsafeMutablePointer<CChar>
    
    public var readBufferSize, writeBufferSize: Int
    ///
    /// The IP Address this Socket is bound to
    ///
    public var IP: IPAddress {
        return _ip
    }
    ///
    /// Indicating whether this Socket is connected or not
    ///
    public var isConnected: Bool {
        return _isConnected
	}
	///
	/// The cached bytes
	///
	public var cache: NSMutableData {
		return _cache
	}
	///
	/// The buffered bytes in a reading operation
	///
	public var readBuffer: UnsafeMutablePointer<CChar> {
		return _readBuffer
	}
	///
	/// The file descriptor representing this socket. (Readonly)
	///
	public internal(set) var socketfd: Int32 = SOCKET_INVALID_DESCRIPTOR
    ///
    /// Delegate for SSL Implementation
    ///
    public var delegate: SSLServiceDelegate? = nil {
        didSet {
            // SSL operatons need higher Buffer Size
            if delegate != nil {
                readBufferSize = SwiftySocket.DEF_SSL_READ_BUFFER_SIZE
                writeBufferSize = SwiftySocket.DEF_SSL_WRITE_BUFFER_SIZE
            }
        }
    }
    
    ///
    /// Create a new instance of the Swifty Socket class
    ///
    /// - Parameter ip: The IP Address to host this socket on
    ///
    public init(ip: IPAddress,
                readBufferSize: Int = SwiftySocket.DEF_READ_BUFFER_SIZE,
                writeBufferSize: Int = SwiftySocket.DEF_WRITE_BUFFER_SIZE) {
        _ip = ip
        _isConnected = false
        self.readBufferSize = readBufferSize
        self.writeBufferSize = writeBufferSize
        _cache = NSMutableData(capacity: readBufferSize)!
		_readBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: readBufferSize)
    }
    
    
    ///
    /// Read data from the socket.
    ///
    /// - Parameters:
    ///		- buffer: The buffer to write the data to.
    /// 	- bufSize:  The maximum number of bytes this should read. Use `truncate: true` to leave remaining
    ///                 bytes in this SwiftySocket's cache
    ///		- truncate: Whether the data should be left on the connection if there is more available data than could fit in `buffer`.
    ///			**Note:** If called with `truncate = true` unretrieved data will be returned on next `read` call.
    ///
    /// - Throws: `SwiftySockets.ERR_BUFFER_TOO_SMALL` if the buffer provided is too small and `truncate = false`.
    ///		Call again with proper buffer size or use `readData(data: NSMutableData)`.
    ///
    /// - Returns: The number of bytes read. (0 if none)
    ///
    public func read(into buffer: UnsafeMutablePointer<CChar>, bufSize: Int, truncate: Bool = false) throws -> Int {
        // Is buffer valid?
        if bufSize < 1 {
            throw SocketError(code: SwiftySocket.ERR_INVALID_BUFFER)
        }
		
        // Check if any bytes are cached/buffered already
        let read = try fillFromCache(into: buffer, bufSize: bufSize, truncate: truncate)
		if read > 0 {
			return read
		}
		
        /// DOWNLOAD OVER NETWORK OPERATION
        
        // For reading, the socket has to be connected
        if !self.isConnected {
            throw SocketError(code: SwiftySocket.ERR_NOT_CONNECTED)
        }
        
        // Read all bytes on the connection stream
        let count = try self.readIntoCache()
        
        // If nothing was read, the connection was closed
        if count < 1 {
            return count
        }
		
		// If data was put into the cache buffer
        return try fillFromCache(into: buffer, bufSize: bufSize, truncate:false)
    }
    
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
    public func write(from data: String) throws -> Int {
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

	
	///
	/// Check whether one or more sockets are available for reading and/or writing
	///
	/// - Parameter sockets: Array of Sockets to be tested.
	///
	/// - Returns: Tuple containing two arrays of Sockets, one each representing readable and writable sockets.
	///
	public class func checkStatus(for sockets: [SwiftySocket]) throws -> (readables: [SwiftySocket], writables: [SwiftySocket]) {
		
		var readables: [SwiftySocket] = []
		var writables: [SwiftySocket] = []
		
		for socket in sockets {
			
			let result = try socket.isReadableOrWritable()
			if result.readable {
				readables.append(socket)
			}
			if result.writable {
				writables.append(socket)
			}
		}
		
		return (readables, writables)
	}
	
	///
	/// Monitor an array of sockets, returning when data is available or timeout occurs.
	///
	/// - Parameters:
	///		- sockets:		An array of sockets to be monitored.
	///		- timeout:		Timeout (in msec) before returning.  A timeout value of 0 will return immediately.
	///		- waitForever:	If true, this function will wait indefinitely regardless of timeout value. Defaults to false.
	///
	/// - Returns: An optional array of sockets which have data available or nil if a timeout expires.
	///
	public class func wait(for sockets: [SwiftySocket], timeout: UInt, waitForever: Bool = false) throws -> [SwiftySocket]? {
		// Validate we have sockets to look for and they are valid...
		for socket in sockets {
			if socket.socketfd == SwiftySocket.SOCKET_INVALID_DESCRIPTOR {
				
				throw Error(code: SwiftySocket.SOCKET_ERR_BAD_DESCRIPTOR, reason: nil)
			}
			if !socket.isActive {
				throw Error(code: SwiftySocket.SOCKET_ERR_NOT_ACTIVE, reason: nil)
			}
		}
		
		// Setup the timeout...
		var timer = timeval()
		if timeout > 0  && !waitForever {
			
			// First get seconds...
			let secs = Int(Double(timeout / 1000))
			timer.tv_sec = secs
			
			// Now get the leftover millisecs...
			let msecs = Int32(Double(timeout % 1000))
			
			// Note: timeval expects microseconds, convert now...
			let uSecs = msecs * 1000
			
			// Now the leftover microseconds...
			#if os(Linux)
				timer.tv_usec = Int(uSecs)
			#else
				timer.tv_usec = Int32(uSecs)
			#endif
		}
		
		// Setup the array of readfds...
		var readfds = fd_set()
		FD.ZERO(set: &readfds)
		
		var highSocketfd: Int32 = 0
		for socket in sockets {
			
			if socket.socketfd > highSocketfd {
				highSocketfd = socket.socketfd
			}
			FD.SET(fd: socket.socketfd, set: &readfds)
		}
		
		// Issue the select...
		var count: Int32 = 0
		if waitForever {
			count = select(highSocketfd + Int32(1), &readfds, nil, nil, nil)
		} else {
			count = select(highSocketfd + Int32(1), &readfds, nil, nil, &timer)
		}
		
		// A count of less than zero indicates select failed...
		if count < 0 {
			
			throw Error(code: Socket.SOCKET_ERR_SELECT_FAILED, reason: String(validatingUTF8: strerror(errno)) ?? "Error: \(errno)")
		}
		
		// A count equal zero, indicates we timed out...
		if count == 0 {
			return nil
		}
		
		// Build the array of returned sockets...
		var dataSockets = [Socket]()
		for socket in sockets {
			
			if FD.ISSET(fd: socket.socketfd, set: &readfds) {
				dataSockets.append(socket)
			}
		}
		
		return dataSockets
	}
	
	///
	/// Creates an Address for a given host and port.
	///
	///	- Parameters:
	/// 	- hostname:			Hostname for this signature.
	/// 	- port:				Port for this signature.
	///
	/// - Returns: An Address instance, or nil if the hostname and port are not valid.
	///
	public class func createAddress(for host: String, on port: Int32) -> Address? {
		
		var info: UnsafeMutablePointer<addrinfo>?
		
		// Retrieve the info on our target...
		var status: Int32 = getaddrinfo(host, String(port), nil, &info)
		if status != 0 {
			
			return nil
		}
		
		// Defer cleanup of our target info...
		defer {
			
			if info != nil {
				freeaddrinfo(info)
			}
		}
		
		var address: Address
		if info!.pointee.ai_family == Int32(AF_INET) {
			
			var addr = sockaddr_in()
			memcpy(&addr, info!.pointee.ai_addr, Int(MemoryLayout<sockaddr_in>.size))
			address = .ipv4(addr)
			
		} else if info!.pointee.ai_family == Int32(AF_INET6) {
			
			var addr = sockaddr_in6()
			memcpy(&addr, info!.pointee.ai_addr, Int(MemoryLayout<sockaddr_in6>.size))
			address = .ipv6(addr)
			
		} else {
			
			return nil
		}
		
		return address
	}
    
	
	private func fillFromCache(into buffer: UnsafeMutablePointer<CChar>, bufSize: Int, truncate: Bool = false) throws -> Int {
		if self.cache.length > 0 {
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
				
				// Reset cache buffer
				self.cache.length = 0
				
				return cacheSize
			}
		} else {
			return 0 //nothing was read
		}
	}
	
    ///
    /// Reads all available data on an open socket into cache.
    ///
    /// - Returns: The number of bytes read.
    ///
    private func readIntoCache() throws -> Int {
		// Clear read buffer
		readBuffer.initialize(to: 0x00)
		
		var recvFlags: Int32 = 0
		if self.cache.length > 0 {
			recvFlags |= Int32(MSG_DONTWAIT)
		}
		
        // Read everything into buffer
        var count: Int = 0
        repeat {
			
            if self.delegate == nil {
                #if os(Linux)
                    count = Glibc.recv(self.socketfd, self.readBuffer, self.readBufferSize, recvFlags)
                #else
                    count = Darwin.recv(self.socketfd, self.readBuffer, self.readBufferSize, recvFlags)
                #endif
            } else {
                
                repeat {
                    do {
                        count = try self.delegate!.receive(buffer: self.readBuffer, bufSize: self.readBufferSize)
                        
						break //stop loop
                    } catch let error {
                        
                        guard let err = error as? SSLError else {
                            throw error
                        }
                        
                        switch err {
                        case .retryNeeded:
                            do {
                                try wait(forRead: true)                                
                            } catch let waitError {
                                throw waitError
                            }
                            continue
                        default:
                            throw err
                        }
                    }
                    
                } while true
                
            }
            // Check for error...
            if count < 0 {
                switch errno {
                    
                    // - Could be an error, but if errno is EAGAIN or EWOULDBLOCK (if a non-blocking socket),
                //	it means there was NO data to read...
                case EAGAIN:
                    fallthrough
                case EWOULDBLOCK:
                    return self.readStorage.length
                    
                case ECONNRESET:
                    // - Handle a connection reset by peer (ECONNRESET) and throw a different exception...
                    throw Error(code: Socket.SOCKET_ERR_CONNECTION_RESET, reason: self.lastError())
                    
                default:
                    // - Something went wrong...
                    throw Error(code: Socket.SOCKET_ERR_RECV_FAILED, reason: self.lastError())
                }
                
            }
            
            if count == 0 {
                
                self.remoteConnectionClosed = true
                return 0
            }
            
            // Save the data in the buffer...
            self.readStorage.append(self.readBuffer, length: count)
            
            // Didn't fill the buffer so we've got everything available...
            if count < self.readBufferSize {
                
                break
            }
            
        } while count > 0
        
        return self.readStorage.length
    }
}
