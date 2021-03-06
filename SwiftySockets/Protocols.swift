//
//  Protocols.swift
//  SwiftySockets
//
//  Created by Marc Rousavy on 30/08/2017.
//  Copyright © 2017 mrousavy. All rights reserved.
//

import Foundation

///
/// Representing an error while reading from a Socket stream
///
/// - ConnectionClosed: The socket connection was closed
///                     by one of the endpoints or unexpectedly
/// - Timeouted: The read process timeouted
/// - NoResponse: No response was received
///
public enum SocketReadError: Error {
    case ConnectionClosed
    case Timeouted
    case NoResponse
}
///
/// Representing an error while writing to a Socket stream
/// 
/// - ConnectionClosed: The socket connection was closed
///                     by one of the endpoints or unexpectedly
/// - Timeouted: The write process timeouted
/// - NoListener: No one is listening on the other end
/// - NoData: There was no data to write
///
public enum SocketWriteError: Error {
    case ConnectionClosed
    case Timeouted
    case NoListener
    case NoData
}

///
/// A protocol to buffered-read on a network connection
///
public protocol NetReader {
    ///
    /// Reads a string from the connection.
    ///
    /// - Returns: The read string, or nil if none
    ///
    func readString() throws -> String?
    
    ///
    /// Reads all available data into an Data object.
    ///
    /// - Parameter data: Data object to contain read data.
    ///
    /// - Returns: Integer representing the number of bytes read.
    ///
    func read(into data: inout Data) throws -> Int
    
    ///
    /// Reads all available data into an NSMutableData object.
    ///
    /// - Parameter data: NSMutableData object to contain read data.
    ///
    /// - Returns: Integer representing the number of bytes read.
    ///
    func read(into data: NSMutableData) throws -> Int
}

///
/// A protocol to buffered-write onto a network connection
///
public protocol NetWriter {
    ///
    /// Writes a string to the connection
    ///
    /// - Parameter data: String data to be written.
    ///
    /// - Throws: Throws when the write process could not
    /// be completed because of a connection error
    ///
    @discardableResult func write(from data: String) throws -> Int
    
    ///
    /// Writes data from Data object.
    ///
    /// - Parameter data: Data object containing the data to be written.
    ///
    @discardableResult func write(from data: Data) throws -> Int
    
    ///
    /// Writes data from NSData object.
    ///
    /// - Parameter data: NSData object containing the data to be written.
    ///
    @discardableResult func write(from data: NSData) throws -> Int
}




///
/// A protocol to buffered-write and read onto a network connection with SSL en/decryption
///
public protocol SSLServiceDelegate {
    
    ///
    /// Initialize SSL Service
    ///
    /// - Parameter asServer:	True for initializing a server, otherwise a client.
    ///
    init(asServer: Bool) throws
    
    
    ///
    /// Deinitialize SSL Service
    ///
    func deinitialize()
    
    ///
    /// Connection accepted callback
    ///
    /// - Parameter socket:	The associated Socket instance.
    ///
    func onAccept(socket: SwiftySocket) throws
    
    ///
    /// Connection established callback
    ///
    /// - Parameter socket:	The associated Socket instance.
    ///
    func onConnect(socket: SwiftySocket) throws
    
    ///
    /// Low level writer
    ///
    /// - Parameters:
    ///		- buffer:		Buffer pointer.
    ///		- bufSize:		Size of the buffer.
    ///
    ///	- Returns the number of bytes written.
    ///
    func send(buffer: UnsafeRawPointer, bufSize: Int) throws -> Int
    
    ///
    /// Low level reader
    ///
    /// - Parameters:
    ///		- buffer:		Buffer pointer.
    ///		- bufSize:		Size of the buffer.
    ///
    ///	- Returns the number of bytes read.
    ///
    func receive(buffer: UnsafeMutableRawPointer, bufSize: Int) throws -> Int
    
    #if os(Linux)
    
    ///
    /// Add a protocol to the list of supported ALPN protocol names. E.g. 'http/1.1' and 'h2'.
    ///
    /// - Parameters:
    ///		- proto:		The protocol name to be added (e.g. 'h2').
    ///
    func addSupportedAlpnProtocol(proto: String)
    
    ///
    /// The negotiated ALPN protocol that has been agreed upon during the handshaking phase.
    /// Will be nil if ALPN hasn't been used or requestsed protocol is not available.
    ///
    var negotiatedAlpnProtocol: String? { get }
    
    #endif
}


///
/// SSL Service Error
///
public enum SSLError: Error {
	/// Retry needed
	case retryNeeded
	
	/// Failure with error code and reason
	case fail(Int, String)
	
	/// The error code itself
	public var code: Int {
		
		switch self {
		case .retryNeeded:
			return -1
			
		case .fail(let (code, _)):
			return Int(code)
		}
	}
	
	/// Error description
	public var description: String {
		
		switch self {
		case .retryNeeded:
			return "Retry operation"
			
		case .fail(let (_, reason)):
			return reason
		}
	}
}
