//
//  SwiftySockets.swift
//  SwiftySockets
//
//  Created by Marc Rousavy on 30/08/2017.
//  Copyright © 2017 mrousavy. All rights reserved.
//

import Foundation


func OpenNew(ip: IPAddress) -> SwiftySocket {
    return SwiftySocket(ip: ip)
}
