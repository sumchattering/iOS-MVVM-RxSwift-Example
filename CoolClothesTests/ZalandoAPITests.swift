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
        super.tearDown()
    }
    
    func testArticlesRequest() {
        let request = ZalandoAPI.ArticlesRequest()
        let currentStub = stub(condition: isHost(kZalandoAPIEndpoint) && isScheme(kZalandoAPIScheme) && isPath(request.path)) { _ in
            let bundle = Bundle(for: ZalandoAPITests.self)
            let stubPath = bundle.path(forResource:  "articlesRequestStub", ofType: "json")
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        self.currentStub = currentStub
        let responseExpectation = expectation(description: "We expect to get a response")
        Session.send(request) { result in
            switch result {
            case .success(let response):
                // Type of `response` is `[Repository]`,
                // which is inferred from `SearchRepositoriesRequest`.
                print(response)
            case .failure(let error):
                XCTFail("Error \(error)")
            }
            
            OHHTTPStubs.removeStub(self.currentStub!)
            self.currentStub = nil
            responseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: { error in
            XCTAssertNil(error, "Error \(error!)")
        })
        
        XCTAssertNil(self.currentStub)
    }
}
