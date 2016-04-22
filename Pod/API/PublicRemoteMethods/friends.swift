//
//  friends.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/13/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public func friendOf(callback callback: Of<[Friend]>.callback) {
        self.execute(.friendOf, callback: callback)
    }
    
    public func getFriendGroups(callback callback: Of<[FriendGroup]>.callback) {
        self.execute(.getFriendGroups, callback: callback)
    }
    
    public struct GetFriendsResult {
        let friends: [Friend]
        let friendOf: [Friend]?
        let friendGroups: [FriendGroup]?
    }
    
    public func getFriends(
        includeFriendOf includeFriendOf: Bool = false,
        includeGroups: Bool = false,
        includeBirthdays: Bool = false,
        callback: Of<GetFriendsResult>.callback) {
            self.execute(
                .getFriends,
                parameters: [
                    ParameterKey.IncludeFriendOf: ParameterValue.fromBool(includeFriendOf),
                    ParameterKey.IncludeGroups: ParameterValue.fromBool(includeGroups),
                    ParameterKey.IncludeBirthdays: ParameterValue.fromBool(includeBirthdays),
                ],
                callback: callback)
    }
}

extension API.GetFriendsResult: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.friends = try ¿value[API.ResponseKey.Friends].arrayOfType(API.Friend.self)
        self.friendOf = try? ¿value[API.ResponseKey.FriendOfs].arrayOfType(API.Friend.self)
        self.friendGroups = try? ¿value[API.ResponseKey.FriendGroups].arrayOfType(API.FriendGroup.self)
    }
}
