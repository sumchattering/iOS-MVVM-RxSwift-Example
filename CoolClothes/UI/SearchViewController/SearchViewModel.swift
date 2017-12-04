//
//  SearchViewModel.swift
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

public final class SearchViewModel: NSObject {
    
    private var searchRequestStub:OHHTTPStubsDescriptor?
    public var shouldLoadFromStubs:Bool = false
    
    let disposaBag: DisposeBag = DisposeBag()
    
    // Input
    let textSearchTrigger: PublishSubject<String> = PublishSubject()
    let rangeSelectTrigger: PublishSubject<CountableClosedRange<Int>> = PublishSubject()
    
    // Output
    lazy private(set) var articles: Observable<[ZalandoArticle]> = self.setupArticles()
    lazy private(set) var isLoading: PublishSubject<Bool> = PublishSubject()
    
    override init() {
        super.init()
        self.setupIsLoading()
    }
    
    // Reactive Setup
    
    fileprivate func setupIsLoading() {
        self.articles
            .subscribe(onNext: { [weak self] (articles) in
                self?.isLoading.on(.next(false))
                }, onError: { [weak self] (error) in
                    self?.isLoading.on(.next(false))
                }, onCompleted: { [weak self] in
                    self?.isLoading.on(.next(false))
                }, onDisposed: { [weak self] in
                    self?.isLoading.on(.next(false))
            }).disposed(by: self.disposaBag)
    }
    
    fileprivate func setupArticles() -> Observable<[ZalandoArticle]> {
        
        return Observable.combineLatest(self.textSearchTrigger, self.rangeSelectTrigger)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] (queryString, queryRange) -> Observable<[ZalandoArticle]> in
                guard let strongSelf = self else { return .empty() }
                
                let request = ZalandoAPI.ArticlesRequest(query: queryString)
                
                if strongSelf.shouldLoadFromStubs {
                    let stubFileName = queryString.count > 0 || queryRange != 0...200 ? "filteredArticlesRequestStub" : "articlesRequestStub"
                    strongSelf.searchRequestStub = stub(condition: isHost(kZalandoAPIEndpoint) && isScheme(kZalandoAPIScheme) && isPath(request.path)) { _ in
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
                    OHHTTPStubs.removeStub(strongSelf.searchRequestStub!)
                    strongSelf.searchRequestStub = nil
                }
                return Observable.just(event)
            }
            .share(replay: 1)
    }
}
