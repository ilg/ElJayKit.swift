//
//  APITests.swift
//  ElJayKit-ExampleTests
//
//  Created by Isaac Greenspan on 12/14/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import XCTest
import ElJayKit
import Alamofire
import VOKMockUrlProtocol

private let APIExpectationTimeout: NSTimeInterval = 5000

class APITests: XCTestCase {
    static let manager: Manager = {
        VOKMockUrlProtocol.setTestBundle(NSBundle(forClass: APITests.self))
        let mockConfig = Alamofire.Manager.sharedInstance.session.configuration
        
        var urlProtocolsToUse: [AnyClass]
        if let currentURLProtocols = mockConfig.protocolClasses {
            urlProtocolsToUse = currentURLProtocols
        } else {
            urlProtocolsToUse = [AnyClass]()
        }
        
        urlProtocolsToUse.insert(VOKMockUrlProtocol.self, atIndex: 0)
        mockConfig.protocolClasses = urlProtocolsToUse
        return Manager(configuration: mockConfig)
    }()
    
    func testLogin() {
        let expectation = expectationWithDescription("API Call Expectation")
        let api = API(server: .LiveJournal, username: "test_user", password: "password", manager: APITests.manager)
        
        api.login(callback: { result in
            // TODO: fix this test, un-comment the assertions below, and add some serious assertions.
//            XCTAssert(result.isSuccess)
//            XCTAssertNotNil(result.value)
//            XCTAssertNil(result.error)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(APIExpectationTimeout,
            handler: { error in XCTAssertNil(error, "API call timed out") })
    }
    
    func testGenerateSession() {
        let expectation = expectationWithDescription("API Call Expectation")
        let api = API(server: .LiveJournal, username: "test_user", password: "password", manager: APITests.manager)
        
        api.generateSession(callback: { result in
            XCTAssert(result.isSuccess)
            XCTAssertNotNil(result.value)
            XCTAssertNil(result.error)
            let session = result.value!
            XCTAssertEqual(session.ljSession, "v2:u17800245:s239:ayMTTTRXW9B:gc403c060ccb3222389b46dfa2bd083c80880ba0c//1")
            XCTAssertEqual(session.ljLoggedIn, "u17800245:s239")
            XCTAssertEqual(session.id, "s239")
            guard
                let sessionCookie = session.ljSessionCookie,
                let loggedInCookie = session.ljLoggedInCookie
                else {
                    XCTFail()
                    expectation.fulfill()
                    return
            }
            XCTAssertEqual(sessionCookie.value, session.ljSession)
            XCTAssertEqual(sessionCookie.domain, ".livejournal.com")
            XCTAssertEqual(loggedInCookie.value, session.ljLoggedIn)
            XCTAssertEqual(loggedInCookie.domain, ".livejournal.com")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(APIExpectationTimeout,
            handler: { error in XCTAssertNil(error, "API call timed out") })
    }
    
    func testExpireSession() {
        let expectation = expectationWithDescription("API Call Expectation")
        let api = API(server: .LiveJournal, username: "test_user", password: "password", manager: APITests.manager)
        
        api.expireSessions(callback: { result in
            XCTAssert(result.isSuccess)
            XCTAssertNotNil(result.value)
            XCTAssertNil(result.error)
            guard let value = result.value else {
                XCTFail()
                expectation.fulfill()
                return
            }
            XCTAssertEqual(value, NSNull())
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(APIExpectationTimeout,
            handler: { error in XCTAssertNil(error, "API call timed out") })
    }
}
