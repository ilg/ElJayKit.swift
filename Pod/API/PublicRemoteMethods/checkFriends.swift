//
//  checkFriends.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/13/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public enum CheckFriendsResult {
        case hasNew
        case nextCheck(NSDate)
        
        public var nextCheck: NSDate? {
            switch self {
            case .hasNew:
                return nil
            case .nextCheck(let date):
                return date
            }
        }
    }
    
    public func checkFriends(
        since lastChecked: NSDate? = nil,
        groups: [FriendGroup]? = nil,
        callback: Of<CheckFriendsResult>.callback) {
            let lastUpdate: String
            if let lastChecked = lastChecked {
                lastUpdate = lastChecked.dateString()
            } else {
                lastUpdate = ""
            }
            let mask: Int32
            if let groups = groups {
                mask = FriendGroup.bitMaskForGroups(groups)
            } else {
                mask = 1
            }
            self.execute(
                .checkFriends,
                parameters: [
                    ParameterKey.LastUpdate: lastUpdate,
                    ParameterKey.Mask: mask,
                ],
                responseType: CheckFriendsResult.self,
                callback: callback)
    }
}

extension API.CheckFriendsResult: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        if let hasNew = value[API.ResponseKey.New].int32  where hasNew != 0 {
            self = .hasNew
        } else if let interval = value[API.ResponseKey.Interval].int32 {
            self = .nextCheck(NSDate(timeIntervalSinceNow: NSTimeInterval(interval)))
        } else {
            throw API.ParseError.BadStructure
        }
    }
}
