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
    /// - Parameter string: String data to be written.
    ///
    /// - Throws: Throws when the write process could not
    /// be completed because of a connection error
    ///
    ///
    @discardableResult func write(from string: String) throws -> Int
    
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
