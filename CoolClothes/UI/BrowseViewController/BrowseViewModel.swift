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

final class BrowseViewModel: NSObject {
    
    // garbage collection
    let disposaBag: DisposeBag = DisposeBag()
    
    // Input
    let reloadTrigger: PublishSubject<Void> = PublishSubject()
    
    // Output
    lazy private(set) var articles: Observable<[ZalandoArticle]> = self.setupArticles()
    
    // Reactive Setup
    fileprivate func setupArticles() -> Observable<[ZalandoArticle]> {
        
        return self.reloadTrigger
            .asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest { (_) -> Observable<[ZalandoArticle]> in
                let request = ZalandoAPI.ArticlesRequest()
                return Session.shared.rx.response(request)
                    .asObservable()
                    .catchError { error in
                        return .empty()
                    }
            }
            .share(replay: 1)
    }
    
}

