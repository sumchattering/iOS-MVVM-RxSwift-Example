//
//  BrowseViewModel.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import APIKit
import OHHTTPStubs

final class BrowseViewModel: NSObject {
    
    public var loadResponseFromStubs:Bool = false
    public var stubLoaded:Bool = false
    private var currentStub:OHHTTPStubsDescriptor?

    // garbage collection
    let disposaBag: DisposeBag = DisposeBag()
    
    // Input
    var reloadTrigger: PublishSubject<Void> = PublishSubject()
    
    // Output
    lazy var articles: Observable<[ZalandoArticle]> = setupArticles()
    
    // Reactive Setup
    fileprivate func setupArticles() -> Observable<[ZalandoArticle]> {
        
        let request = ZalandoAPI.ArticlesRequest()
        if self.currentStub == nil {
            self.currentStub = stub(condition: isHost(kZalandoAPIEndpoint) && isScheme(kZalandoAPIScheme) && isPath(request.path)) { _ in
                let stubPath = Bundle.main.path(forResource:  "articlesRequestStub", ofType: "json")
                return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
            }
        }
        
        return self.reloadTrigger
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest { (_) -> Observable<[ZalandoArticle]> in
                return Session.shared.rx.response(request)
                    .asObservable()
                    .catchError { error in
                        return .empty()
                    }
            }
            .share(replay: 1)
    }
    
}

