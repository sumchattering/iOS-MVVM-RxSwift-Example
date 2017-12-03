//
//  CoolClothesTests.swift
//  CoolClothesTests
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import XCTest
import Foundation
import APIKit
import RxSwift
import RxCocoa
import OHHTTPStubs

@testable import CoolClothes

class ZalandoAPITests: XCTestCase {
    private var currentStub:OHHTTPStubsDescriptor?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        if let currentStub = self.currentStub {
            OHHTTPStubs.removeStub(currentStub)
        }
        super.tearDown()
    }
    
    func testArticlesRequest() {
        let request = ZalandoAPI.ArticlesRequest()
        givenStub(path: request.path, stubFileName: "articlesRequestStub")
        let responseExpectation = expectation(description: "We expect to get a response")
        Session.send(request) { results in
            switch results {
            case .success(let results):
                XCTAssert(results.count==21, "There must be 21 results")
            case .failure(let error):
                XCTFail("Error \(error)")
            }
            responseExpectation.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: { error in
            XCTAssertNil(error, "Error \(error!)")
        })
    }
    
    func givenStub(path:String, stubFileName:String) {
        let currentStub = stub(condition: isHost(kZalandoAPIEndpoint) && isScheme(kZalandoAPIScheme) && isPath(path)) { _ in
            let bundle = Bundle(for: ZalandoAPITests.self)
            let stubPath = bundle.path(forResource:  stubFileName, ofType: "json")
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        self.currentStub = currentStub
    }
}
