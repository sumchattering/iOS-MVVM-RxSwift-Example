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
    
    private var articleRequestStub:OHHTTPStubsDescriptor?
    
    public var shouldLoadFromStubs:Bool = false

    // garbage collection
    let disposaBag: DisposeBag = DisposeBag()
    
    // Input
    var reloadTrigger: PublishSubject<Void> = PublishSubject()
    
    // Output
    lazy var articles: Observable<[ZalandoArticle]> = setupArticles()
    
    // Reactive Setup
    fileprivate func setupArticles() -> Observable<[ZalandoArticle]> {
        
        return self.reloadTrigger
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] (_) -> Observable<[ZalandoArticle]> in
                guard let strongSelf = self else { return .empty() }
                
                let request = ZalandoAPI.ArticlesRequest()
                
                if strongSelf.shouldLoadFromStubs {
                    strongSelf.articleRequestStub = stub(condition: isHost(kZalandoAPIEndpoint) && isScheme(kZalandoAPIScheme) && isPath(request.path)) { _ in
                        let stubFileName = "articlesRequestStub"
                        let stubPath = Bundle.main.path(forResource:  stubFileName, ofType: "json")
                        return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
                    }
                }

                return Session.shared.rx.response(request)
                    .asObservable()
                    .catchError { error in
                        return .empty()
                    }
            }
            .flatMapLatest {[weak self] event -> Observable<[ZalandoArticle]> in
                guard let strongSelf = self else { return .empty() }
                
                if strongSelf.shouldLoadFromStubs {
                    OHHTTPStubs.removeStub(strongSelf.articleRequestStub!)
                    strongSelf.articleRequestStub = nil
                }
                return Observable.just(event)
            }
            .share(replay: 1)
    }
    
}

