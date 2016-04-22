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
        public let userPics: [UserPic]
        public let defaultPic: UserPic
        // TODO: handle moods
    }
    public struct UserPic {
        public let url: NSURL
        public let keywords: String
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
            callback: callback)
    }
}

extension API.LoginResult: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.fullName = try ¿value[API.ResponseKey.FullName].ljString
        self.message = value[API.ResponseKey.Message].ljString
        self.friendGroups = try ¿value[API.ResponseKey.FriendGroups].arrayOfType(API.FriendGroup.self)
        self.useJournals = try ¿value[API.ResponseKey.Usejournals].array?.flatMap({ $0.ljString })
        self.userPics = zip(
            try ¿value[API.ResponseKey.UserpicURLs].array,
            try ¿value[API.ResponseKey.UserpicKeywords].array
            ).flatMap({ ( urlNode, keywordsNode ) in
                guard
                    let urlString = urlNode.ljString,
                    let url = NSURL(string: urlString),
                    let keywords = keywordsNode.ljString
                    else {
                        return nil
                }
                return API.UserPic(url: url, keywords: keywords)
            })
        let defaultPicUrlString = try ¿value[API.ResponseKey.DefaultUserpicURL].ljString
        self.defaultPic = try ¿self.userPics.filter({ userPic in
            return userPic.url.absoluteString == defaultPicUrlString
        }).first
    }
}