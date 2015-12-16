//
//  Error.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/10/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation

extension API {
    public enum Error: ErrorType {
        case Network(NSError)
        case Parsing
    }
}
