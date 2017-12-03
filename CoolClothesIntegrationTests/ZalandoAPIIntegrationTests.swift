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
import RxBlocking

@testable import CoolClothes

class ZalandoAPIIntegrationTests: XCTestCase {
    
    private let sharedSession = Session.shared
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testArticlesRequest() {
        let result = sharedSession.rx.response(ZalandoAPI.ArticlesRequest())
            .toBlocking()
            .materialize()
        
        switch result {
        case .completed(let elements):
            XCTAssertNotNil(elements)
        case .failed(_, let error):
            XCTFail("Error \(error).")
        }
    }
}
