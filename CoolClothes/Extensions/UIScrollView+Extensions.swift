//
//  UIScrollView+Extensions.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/4/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    public var reachedBottom: Observable<Void> {
        let scrollView = self.base as UIScrollView
        return self.contentOffset.flatMap{ [weak scrollView] (contentOffset) -> Observable<Void> in
            guard let scrollView = scrollView else { return Observable.empty() }
            let visibleHeight = scrollView.frame.height - self.base.contentInset.top - scrollView.contentInset.bottom
            let y = contentOffset.y + scrollView.contentInset.top
            let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
            return (y > threshold) ? Observable.just(()) : Observable.empty()
        }
    }
    
    public var startedDragging: Observable<Void> {
        let scrollView = self.base as UIScrollView
        return scrollView.panGestureRecognizer.rx
            .event
            .filter({ $0.state == .began })
            .map({ _ in () })
    }
}
