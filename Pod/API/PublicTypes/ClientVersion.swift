//
//  ClientVersion.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/11/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public struct ClientVersion {
        private static let defaultPlatform: String = {
            #if os(iOS)
                return "iOS"
            #elseif os(watchOS)
                return "Watch"
            #elseif os(tvOS)
                return "TV"
            #elseif os(OSX)
                return "Mac"
            #else
                return "Swift"
            #endif
        }()
        private static let defaultProduct: String = {
            let mainBundle = NSBundle.mainBundle()
            return mainBundle.objectForInfoDictionaryKey(kCFBundleNameKey as String) as? String ?? "ElJayKit"
        }()
        private static let defaultVersion: String = {
            let mainBundle = NSBundle.mainBundle()
            return mainBundle.objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String ?? String(ElJayKitVersionNumber)
        }()
        
        public var platform: String! = ClientVersion.defaultPlatform {
            didSet {
                if self.platform == nil {
                    self.platform = ClientVersion.defaultPlatform
                }
            }
        }
        public var product: String! = ClientVersion.defaultProduct {
            didSet {
                if self.product == nil {
                    self.product = ClientVersion.defaultProduct
                }
            }
        }
        public var version: String! = ClientVersion.defaultVersion {
            didSet {
                if self.version == nil {
                    self.version = ClientVersion.defaultVersion
                }
            }
        }
        
        public var string: String {
            return "\(self.platform)-\(self.product)/\(self.version)"
        }
    }
}

extension API.ClientVersion: XMLRPCValueConvertible {
    public var xmlRpcKind: XMLRPCValueKind { return .String }
    public var xmlRpcValue: String { return self.string }
}
