//
//  Challenge.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/10/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC
import MD5Digest

extension API {
    struct Challenge {
        let authScheme: String
        let challenge: String
        let expires: NSDate
        
        var isExpired: Bool {
            return self.expires.isLessThanOrEqualTo(NSDate())
        }
        
        func response(passwordMD5 passwordMD5: String) -> String {
            // Response is md5( challenge + md5([password]) )   where md5() returns the hex digest.
            return ("\(self.challenge)\(passwordMD5)" as NSString).MD5Digest()
        }
    }
    
    /**
     Get a challenge for challenge-response authentication.
     
     - parameter callback: The callback to execute with the challenge or error
     */
    func getChallenge(callback: Of<Challenge>.callback) {
        self.simpleExecute(.getChallenge, callback: { result in
            // Error if we didn't get a well-formed challenge.
            guard
                let value = result.value as? XMLRPCNode,
                let challenge = try? Challenge(xmlrpcNode: value)
                else {
                callback(.Failure(.Parsing))
                return
            }
            
            // Success.
            callback(.Success(challenge))
        })
    }
}

extension API.Challenge: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.authScheme = try ¿value[API.ResponseKey.AuthScheme].ljString
        self.challenge = try ¿value[API.ResponseKey.Challenge].ljString
        guard
            let expireTimeStamp = value[API.ResponseKey.ExpireTimeStamp].int32,
            let serverTimeStamp = value[API.ResponseKey.ServerTimeStamp].int32
            else {
                throw UnwrapError.Nil
        }
        self.expires = NSDate(timeIntervalSinceNow: NSTimeInterval(expireTimeStamp - serverTimeStamp))
    }
}