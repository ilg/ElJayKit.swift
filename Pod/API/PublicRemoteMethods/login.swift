//
//  login.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/12/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public struct LoginResult {
        public let fullName: String
        public let message: String?
        public let friendGroups: [FriendGroup]
        public let useJournals: [String]
        public let picKeywords: [String]
        public let picUrls: [String]
        public let defaultPicUrl: String
    }
    
    public func login(callback callback: Of<LoginResult>.callback) {
        self.execute(
            .login,
            parameters: [
                // TODO: allow the caller to pass in these parameters
                ParameterKey.GetPicKws: ParameterValue.Yes,
                ParameterKey.GetPicKwUrls: ParameterValue.Yes,
                ParameterKey.GetMoods: ParameterValue.Yes,  // TODO: fix this parameter
            ],
            responseType: LoginResult.self,
            callback: callback)
    }
}

extension API.LoginResult: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.fullName = try ¿value[API.ResponseKey.FullName].ljString
        self.message = value[API.ResponseKey.Message].ljString
        self.friendGroups = try ¿value[API.ResponseKey.FriendGroups].arrayOfType(API.FriendGroup.self)
        self.useJournals = try ¿value[API.ResponseKey.Usejournals].array?.flatMap({ $0.ljString })
        self.picKeywords = try ¿value[API.ResponseKey.UserpicKeywords].array?.flatMap({ $0.ljString })
        self.picUrls = try ¿value[API.ResponseKey.UserpicURLs].array?.flatMap({ $0.ljString })
        self.defaultPicUrl = try ¿value[API.ResponseKey.DefaultUserpicURL].ljString
    }
}
