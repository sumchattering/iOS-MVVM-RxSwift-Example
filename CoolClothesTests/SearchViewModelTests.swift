//
//  SearchViewModelTests.swift
//  CoolClothesTests
//
//  Created by Chatterjee, Sumeru(AWF) on 12/4/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import XCTest
import Foundation
import APIKit
import RxSwift
import RxCocoa
import OHHTTPStubs

@testable import CoolClothes

class SearchViewModelTests: XCTestCase {
    private var currentStub:OHHTTPStubsDescriptor?
    private let disposaBag: DisposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReceiveSearchResults() {
        let viewModel = SearchViewModel()
        viewModel.shouldLoadFromStubs = true
        let articleExpectation = expectation(description: "We should receive an article")
        viewModel.articles.subscribe { event in
            switch event {
            case .next(let elements):
                XCTAssert(elements.count > 0, "There should be some articles")
            case .error(let error):
                XCTFail("error \(error)")
            case .completed:
                break
            }
            articleExpectation.fulfill()
            }.disposed(by: disposaBag)
        viewModel.textSearchTrigger.onNext("query")
        viewModel.rangeSelectTrigger.onNext(0...200)
        waitForExpectations(timeout: 10, handler: { error in
            XCTAssertNil(error)
        })
    }
}
