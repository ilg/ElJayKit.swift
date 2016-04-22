//
//  getUserTags.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/14/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public enum TagSecurityLevel: String {
        case Public = "public"
        case Private = "private"
        case Friends = "friends"
        case Group = "group"
    }
    
    public struct Tag {
        let name: String
        let visibleToS2: Bool
        let securityLevel: TagSecurityLevel
        let uses: Int32?
        let usesPublic: Int32?
        let usesPrivate: Int32?
        let usesFriends: Int32?
        let usesGroups: Int32?  // TODO: this may need to be some kind of array of structs or something
    }
    
    public func getUserTags(useJournal: String? = nil, callback: Of<[Tag]>.callback) {
        var parameters: [String: Any] = Dictionary()
        if let useJournal = useJournal {
            parameters[ParameterKey.UseJournal] = useJournal
        }
        self.execute(
            .getUserTags,
            parameters: parameters,
            callback: callback)
    }
}

extension API.Tag: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.name = try ¿value[API.ResponseKey.Name].ljString
        self.visibleToS2 = (value[API.ResponseKey.Display].int32 == 1)
        self.securityLevel = try ¿API.TagSecurityLevel(rawValue: try ¿value[API.ResponseKey.SecurityLevel].ljString)
        self.uses = value[API.ResponseKey.Uses].int32
        self.usesPublic = value[API.ResponseKey.Security][API.ResponseKey.Public].int32
        self.usesPrivate = value[API.ResponseKey.Security][API.ResponseKey.Private].int32
        self.usesFriends = value[API.ResponseKey.Security][API.ResponseKey.Friends].int32
        self.usesGroups = value[API.ResponseKey.Security][API.ResponseKey.Groups].int32
    }
}
