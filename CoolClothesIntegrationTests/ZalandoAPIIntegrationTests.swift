//
//  CoolClothesIntegrationTests.swift
//  CoolClothesIntegrationTests
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import XCTest
import Foundation
import APIKit
import RxSwift
import RxCocoa

@testable import CoolClothes

class ZalandoAPIIntegrationTests: XCTestCase {
    
    private let sharedSession = Session.shared
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        executeZalandoAPIRequest(request: ZalandoAPI.ArticlesRequest(), completion: { articles in
            XCTAssert(articles.count > 0, "There must be nonzero results")
            print("Articles Success!!!")
            dump(articles)
        })
    }
    
    func executeZalandoAPIRequest<T: Request>(request: T, completion: @escaping ((T.Response) -> Void)) {
        let response = sharedSession.rx.response(request)
        let responseExpectation = expectation(description: "We will receive a response from server")
        let _ = response.subscribe { response in
            
            switch response {
            case .error(let error):
                XCTAssertNil(error)
            case .success(let response):
                XCTAssertNotNil(response)
                completion(response)
            }
            responseExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error)
        }
    }
    
}
