//
//  SwiftySocket.swift
//  SwiftySockets
//
//  Created by Marc Rousavy on 30/08/2017.
//  Copyright © 2017 mrousavy. All rights reserved.
//

import Foundation


// The swifty socket class
public class SwiftySocket {
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
        _ip = ip
    }
}
