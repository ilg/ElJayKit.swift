//
//  API.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/10/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireXMLRPC
import MD5Digest

/**
 *  Provides LiveJournal API functionality for a given server and user.
 */
public struct API {
    public typealias BaseCallback = Of<Any>.callback
    
    /// The client version to send to the server
    public var clientVersion: ClientVersion! = ClientVersion() {
        didSet {
            if self.clientVersion == nil {
                self.clientVersion = ClientVersion()
            }
        }
    }
    
    /// The Alamofire Manager to use to make calls
    private let manager: Manager
    /// The target server
    let server: Server
    /// The user
    let username: String
    /// The MD5 hash of the password
    private let passwordMD5: String
    
    /**
     Create an API instance for the given server and the given user with the given plaintext password.
     
     - parameter server:   The server to target
     - parameter username: The user
     - parameter password: The user's plaintext password (only its MD5 hash is stored)
     
     - returns: The API instance
     */
    public init(server: Server, username: String, password: String, manager: Manager = Manager.sharedInstance) {
        self.init(server: server, username: username, passwordMD5: password.MD5Digest(), manager: manager)
    }
    
    /**
     Create an API instance for the given server and the given user with the given MD5 password hash.
     
     - parameter server:   The server to target
     - parameter username: The user
     - parameter passwordMD5: The MD5 hash of the user's password
     
     - returns: The API instance
     */
    public init(server: Server, username: String, passwordMD5: String, manager: Manager = Manager.sharedInstance) {
        self.server = server
        self.username = username
        self.passwordMD5 = passwordMD5
        self.manager = manager
    }
    
    /**
     Basic internal XMLRPC call wrapper.
     
     - parameter method:     The method to call
     - parameter parameters: The parameters of the call, if any
     - parameter callback:   The callback to execute with the result of the call
     */
    func simpleExecute(method: Method, parameters: [String: Any]? = nil, callback: BaseCallback) {
        let paramArray: [Any]?
        if let params = parameters {
            paramArray = [params]
        } else {
            paramArray = nil
        }
        self.manager
            .requestXMLRPC(
                self.server.xmlrpcEndpoint,
                methodName: method.methodName,
                parameters: paramArray)
            .responseXMLRPC({ response in
                // Pass along obvious errors.
                guard let value = response.result.value?[0] where response.result.isSuccess else {
                    callback(.Failure(.Network(response.result.error!)))
                    return
                }
                
                // Success.
                callback(.Success(value))
            })
    }
    
    /**
     Internal XMLRPC call handler.  Handles challenge-response authentication.
     
     - parameter method:     The method to call
     - parameter parameters: The parameters of the call, if any
     - parameter callback:   The callback to execute with the result of the call
     */
    func execute(method: Method, parameters: [String: Any]? = nil, callback: BaseCallback) {
        self.getChallenge({ result in
            // Pass along obvious errors.
            guard let challenge = result.value where result.isSuccess else {
                callback(.Failure(result.error!))
                return
            }
            
            // Build up the parameter dictionary.
            var params: [String: Any] = [
                ParameterKey.AuthMethod: ParameterValue.AuthMethodChallenge,
                ParameterKey.AuthChallenge: challenge.challenge,
                ParameterKey.AuthResponse: challenge.response(passwordMD5: self.passwordMD5),
                ParameterKey.Username: self.username,
                ParameterKey.ProtocolVersion: ParameterValue.ProtocolVersion1,
                ParameterKey.ClientVersion: self.clientVersion,
            ]
            if let parameters = parameters {
                params += parameters
            }
            
            self.simpleExecute(method, parameters: params, callback: callback)
        })
    }
}
