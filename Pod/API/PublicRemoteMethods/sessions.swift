//
//  sessions.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/13/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public struct Session {
        public let ljSession: String
        let fields: [String]
        public let id: String
        public let ljLoggedIn: String
        var server: Server?
        public var ljSessionCookie: NSHTTPCookie? {
            guard let server = self.server else { return nil }
            return NSHTTPCookie(properties: [
                NSHTTPCookieName: "ljsession",
                NSHTTPCookieValue: self.ljSession,
                NSHTTPCookieDomain: server.cookieDomain,
                NSHTTPCookiePath: "/",
                ])
        }
        public var ljLoggedInCookie: NSHTTPCookie? {
            guard let server = self.server else { return nil }
            return NSHTTPCookie(properties: [
                NSHTTPCookieName: "ljsession",
                NSHTTPCookieValue: self.ljLoggedIn,
                NSHTTPCookieDomain: server.cookieDomain,
                NSHTTPCookiePath: "/",
                ])
        }
    }
    
    public func generateSession(longSession longSession: Bool = false, fixedToIP: Bool = true, callback: Of<Session>.callback) {
        self.execute(
            .sessionGenerate,
            parameters: [
                ParameterKey.SessionExpiration:
                    (longSession
                        ? ParameterValue.SessionExpirationLong
                        : ParameterValue.SessionExpirationShort),
                ParameterKey.SessionIPFixed: ParameterValue.fromBool(fixedToIP),
            ],
            responsePostProcess: { originalSession in
                var session = originalSession
                session.server = self.server
                return session
            },
            callback: callback)
    }
    
    public func expireSessions(sessions: [Session]? = nil, callback: Of<NSNull>.callback) {
        let parameters: [String: Any]
        if let sessions = sessions {
            parameters = [
                ParameterKey.ExpireSessions: sessions.map({ $0.id }),
            ]
        } else {
            parameters = [
                ParameterKey.ExpireAllSessions: ParameterValue.Yes,
            ]
        }
        self.execute(.sessionExpire, parameters: parameters, callback: { result in
            if result.isSuccess {
                callback(.Success(NSNull()))
            } else {
                callback(.Failure(result.error!))
            }
        })
    }
}

extension API.Session: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.ljSession = try ¿value[API.ResponseKey.Session].ljString
        self.fields = self.ljSession.componentsSeparatedByString(":")
        guard self.fields.count > 2 else {
            throw API.ParseError.BadStructure
        }
        self.id = self.fields[2]
        self.ljLoggedIn = self.fields[1...2].joinWithSeparator(":")
    }
}
