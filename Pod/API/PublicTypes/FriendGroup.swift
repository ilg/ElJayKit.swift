//
//  FriendGroup.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/13/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public struct FriendGroup {
        public let id: Int32
        public let name: String
        public let sortOrder: Int32
        public let isPublic: Bool
        public let bitMask: Int32
        
        public static func bitMaskForGroups(groups: [FriendGroup]) -> Int32 {
            return groups.reduce(0, combine: { bitMask, friendGroup in
                return bitMask | friendGroup.bitMask
            })
        }
    }
}

extension API.FriendGroup: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.id = try ¿value[API.ResponseKey.Id].int32
        self.name = try ¿value[API.ResponseKey.Name].ljString
        self.sortOrder = try ¿value[API.ResponseKey.SortOrder].int32
        self.isPublic = (try ¿value[API.ResponseKey.Public].int32 != 0)
        self.bitMask = 1 << self.id
    }
}
