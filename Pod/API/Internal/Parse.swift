//
//  Parse.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/12/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation
import AlamofireXMLRPC

protocol XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws
}

extension API {
    enum ParseError: ErrorType {
        case BadStructure
        case BadStructureInArray
    }
    
    /**
     Internal XMLRPC call handler with single-item response parsing.
     
     - parameter method:              The method to call
     - parameter parameters:          The parameters of the call, if any
     - parameter responseType:        The type of item expected in the response
     - parameter responsePostProcess: A function to apply to the parsed response before invoking the callback
     - parameter callback:            The callback to execute with the result of the call
     */
    func execute<ResponseType: XMLRPCDeserializable>(
        method: Method,
        parameters: [String: Any]? = nil,
        responseType: ResponseType.Type,
        responsePostProcess: (ResponseType) -> (ResponseType?) = { $0 },
        callback: Of<ResponseType>.callback) {
            self.execute(method, parameters: parameters, callback: { result in
                // Pass along obvious errors.
                guard let value = result.value as? XMLRPCNode where result.isSuccess else {
                    callback(.Failure(result.error!))
                    return
                }
                
                // Error if we didn't get a well-formed response structure.
                guard let parsedValue = try? ResponseType(xmlrpcNode: value) else {
                    callback(.Failure(.Parsing))
                    return
                }
                
                // Apply post-processing.
                guard let postProcessedValue = responsePostProcess(parsedValue) else {
                    callback(.Failure(.Parsing))
                    return
                }
                
                // Success.
                callback(.Success(postProcessedValue))
            })
    }
    
    /**
     Internal XMLRPC call handler with array response parsing.
     
     - parameter method:              The method to call
     - parameter parameters:          The parameters of the call, if any
     - parameter responseArrayOfType: The type of item expected inside the response array
     - parameter responsePostProcess: A function to apply to the parsed response array before invoking the callback
     - parameter callback:            The callback to execute with the result of the call
     */
    func execute<ResponseItemType: XMLRPCDeserializable>(
        method: Method,
        parameters: [String: Any]? = nil,
        responseArrayOfType: ResponseItemType.Type,
        responsePostProcess: ([ResponseItemType]) -> ([ResponseItemType]?) = { $0 },
        callback: Of<[ResponseItemType]>.callback) {
            self.execute(
                method,
                parameters: parameters,
                responseType: ArrayContainer<ResponseItemType>.self,
                responsePostProcess: { arrayContainer in
                    guard let processedArray = responsePostProcess(arrayContainer.array) else {
                        return nil
                    }
                    return ArrayContainer<ResponseItemType>(array: processedArray)
                },
                callback: { result in
                    if let value = result.value where result.isSuccess {
                        callback(.Success(value.array))
                    } else {
                        callback(.Failure(result.error!))
                    }
            })
    }
    
}

extension XMLRPCNode {
    /// If the node has a string value, return that; otherwise, if the node has a base64 value, assume it's UTF8 data and convert that to a string.
    var ljString: String? {
        if let string = self.string {
            return string
        }
        guard let data = self.data else {
            return nil
        }
        return String(data: data, encoding: NSUTF8StringEncoding)
    }
    
    /**
     Convert a node to an array with items of a known type
     
     - parameter type: The type of the items in the array
     
     - throws: `API.ParseError.BadStructureInArray` if any item in the array failed to parse; `UnwrapError.Nil` if the node is not an array
     
     - returns: An array of items of the given type
     */
    func arrayOfType<ItemType: XMLRPCDeserializable>(type: ItemType.Type) throws -> [ItemType] {
        let arrayOfNodes = try ¿self.array
        let arrayOfItems = arrayOfNodes.flatMap({ try? ItemType(xmlrpcNode: $0) })
        guard arrayOfNodes.count == arrayOfItems.count else {
            throw API.ParseError.BadStructureInArray
        }
        return arrayOfItems
    }
}

/**
 *  Helper to parse array responses.
 */
private struct ArrayContainer<T: XMLRPCDeserializable> {
    let array: [T]
}
extension ArrayContainer: XMLRPCDeserializable {
    init(xmlrpcNode value: XMLRPCNode) throws {
        let key = try ¿value.dictionary?.keys.first
        self.array = try ¿value[key].arrayOfType(T)
    }
}
