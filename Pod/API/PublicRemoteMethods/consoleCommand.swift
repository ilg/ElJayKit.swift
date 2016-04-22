//
//  consoleCommand.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/14/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

extension API {
    public enum ConsoleCommandOutputLineType: String {
        case Normal = ""
        case Info = "info"
        case Error = "error"
        case Success = "success"
    }
    
    public struct ConsoleCommandOutputLine {
        let type: ConsoleCommandOutputLineType
        let text: String
        
        var display: String {
            return NSString(format: "[%-7s] %@", (self.type.rawValue as NSString).UTF8String, self.text) as String
        }
    }
    
    public struct ConsoleCommandOutput {
        let isSuccess: Bool
        let output: [ConsoleCommandOutputLine]
        
        public var display: String {
            return self.output.map({ $0.display }).joinWithSeparator("\n")
        }
    }
    
    public typealias ConsoleCommandCallback = Of<[ConsoleCommandOutput]>.callback
    
    public func consoleCommand(command command: String, callback: ConsoleCommandCallback) {
        consoleCommand(commands: [command], callback: callback)
    }
    
    public func consoleCommand(command command: [String], callback: ConsoleCommandCallback) {
        consoleCommand(commands: [command], callback: callback)
    }
    
    public func consoleCommand(commands commands: [String], callback: ConsoleCommandCallback) {
        consoleCommand(
            genericCommands: commands,
            callback: callback)
    }
    
    public func consoleCommand(commands commands: [[String]], callback: ConsoleCommandCallback) {
        consoleCommand(
            genericCommands: commands,
            callback: callback)
    }
    
    private func consoleCommand(genericCommands commands: [AnyObject], callback: ConsoleCommandCallback) {
        self.execute(
            .consoleCommand,
            parameters: [
                ParameterKey.Commands: commands,
            ],
            callback: callback)
    }
}

extension API.ConsoleCommandOutputLine: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.type = try ¿API.ConsoleCommandOutputLineType(rawValue: try ¿value[0].ljString)
        self.text = value[1].ljString ?? ""
    }
}

extension API.ConsoleCommandOutput: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        self.isSuccess = (try ¿value[API.ResponseKey.Success].int32 != 0)
        self.output = try ¿value[API.ResponseKey.Output].arrayOfType(API.ConsoleCommandOutputLine.self)
    }
}
