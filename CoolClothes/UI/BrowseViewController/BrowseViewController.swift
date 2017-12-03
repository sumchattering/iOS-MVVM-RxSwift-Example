//
//  BrowseViewController.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BrowseViewController: BaseCollectionViewController {

    fileprivate let refreshControl: UIRefreshControl = UIRefreshControl()

    fileprivate let viewModel: BrowseViewModel = BrowseViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupCollectionView()
        self.setupBindings()
        self.viewModel.reloadTrigger.onNext(())
    }
    
    fileprivate func setupUI() {
        self.title = NSLocalizedString("Featured", comment: "Featured View Controller Title")
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.registerReusableCell(ClothingCollectionViewCell.self)
        self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.collectionView.addSubview(self.refreshControl)
    }
    
    fileprivate func setupBindings() {
        // Bind refresh control to data reload
        self.refreshControl.rx
            .controlEvent(.valueChanged)
            .filter({ self.refreshControl.isRefreshing })
            .bind(to: self.viewModel.reloadTrigger)
            .disposed(by: self.disposeBag)
        
        // Bind view model films to the collection view
        self.viewModel.articles
            .bind(to: self.collectionView.rx.items(cellIdentifier: ClothingCollectionViewCell.DefaultReuseIdentifier, cellType: ClothingCollectionViewCell.self)) {
                (row, article, cell) in
                cell.populate(imageURL: URL(string:article.images[0].mediumURL), title: article.season)
            }.disposed(by: self.disposeBag)
        
        // Bind view model films to the refresh control
        self.viewModel.articles
            .subscribe { _ in
                self.refreshControl.endRefreshing()
            }.disposed(by: self.disposeBag)
    }
}
