//
//  Friend.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/13/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public enum FriendType: String {
        case Community = "community"
        case Syndicated = "syndicated"
        case News = "news"
        case Shared = "shared"
        case Identity = "identity"
    }
    public struct Friend {
        let username: String
        let fullName: String
        let type: FriendType?
        let identityType: String?
        let identityValue: String?
        let identityDisplay: String?
        let birthday: String?  // TODO: fix this type
        let fgColorHex: String
        let bgColorHex: String
        let groupMask: Int32
    }
}

extension API.Friend: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.username = try ¿value[API.ResponseKey.FriendUsername].ljString
        self.fullName = try ¿value[API.ResponseKey.FriendFullName].ljString
        if let typeString = value[API.ResponseKey.FriendType].ljString,
            let type = API.FriendType(rawValue: typeString) {
                self.type = type
        } else {
            self.type = nil
        }
        if self.type == .Identity {
            self.identityType = try ¿value[API.ResponseKey.FriendIdentityType].ljString
            self.identityValue = try ¿value[API.ResponseKey.FriendIdentityValue].ljString
            self.identityDisplay = try ¿value[API.ResponseKey.FriendIdentityDisplay].ljString
        } else {
            self.identityType = nil
            self.identityValue = nil
            self.identityDisplay = nil
        }
        self.birthday = value[API.ResponseKey.FriendBirthday].ljString
        self.fgColorHex = try ¿value[API.ResponseKey.FriendFGColor].ljString
        self.bgColorHex = try ¿value[API.ResponseKey.FriendBGColor].ljString
        if let groupMask = value[API.ResponseKey.FriendGroupMask].int32 {
            self.groupMask = groupMask
        } else {
            self.groupMask = 0
        }
    }
}
