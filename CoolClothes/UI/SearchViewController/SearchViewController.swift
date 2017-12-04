//
//  SearchViewController.swift
//  CoolClothes
//
//  Created by Chatterjee, Sumeru(AWF) on 12/3/17.
//  Copyright © 2017 Chatterjee, Sumeru. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RangeSeekSlider

class SearchViewController: BaseCollectionViewController {
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentOverlayBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var rangeSeekSlider: RangeSeekSlider!
    
    static let searchViewGreyColor = UIColor(red: 200.0/255, green: 200/255, blue: 200/255, alpha: 1.0)
    
    fileprivate let viewModel: SearchViewModel = SearchViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupCollectionView()
        self.setupBindings()
        self.viewModel.shouldLoadFromStubs = true
    }
    
    fileprivate func setupUI() {
        
        self.title = NSLocalizedString("Search", comment: "Search View Controller Title")
        self.searchBar.returnKeyType = .done
        self.searchBar.delegate = self
        if let searchTextField: UITextField = self.searchBar.subviews[0].subviews[1] as? UITextField {
            searchTextField.enablesReturnKeyAutomatically = false
            let attributes = [
                NSAttributedStringKey.foregroundColor: SearchViewController.searchViewGreyColor,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)
            ]
            let placeholderString = NSLocalizedString("Search Articles", comment:"Search Placeholder Text")
            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes:attributes)
        }
        self.searchBar.keyboardAppearance = .dark
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        self.placeholderLabel.textColor = SearchViewController.searchViewGreyColor
        self.placeholderLabel.text = NSLocalizedString("Search thousands of articles...", comment:"Search Placeholder Label Text")
        self.placeholderView.tintColor = SearchViewController.searchViewGreyColor
        self.rangeSeekSlider.tintColor = SearchViewController.searchViewGreyColor
        
        self.rangeSeekSlider.numberFormatter.numberStyle = .currency
        self.rangeSeekSlider.numberFormatter.locale = Locale(identifier: Locale.current.identifier)
        self.rangeSeekSlider.maxValue = 200
        self.rangeSeekSlider.selectedMaxValue = 200
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.registerReusableCell(ClothingCollectionViewCell.self)
        self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    fileprivate func setupBindings() {
        
        // Bind search bar text to the view model
        self.searchBar.rx
            .text
            .orEmpty
            .bind(to: self.viewModel.textSearchTrigger)
            .disposed(by: self.disposeBag)
        
        // Bind view model films to the table view
        self.viewModel
            .articles
            .bind(to: self.collectionView.rx.items(cellIdentifier: ClothingCollectionViewCell.DefaultReuseIdentifier, cellType: ClothingCollectionViewCell.self)) {
                (row, article, cell) in
                let title = "\(article.season) \(article.seasonYear)"
                let description = article.name
                cell.populate(imageURL: URL(string:article.images[0].mediumURL), title: title, description: description)
            }.disposed(by: self.disposeBag)
        
        // Bind scrolling updates to dismiss keyboard when tableView is not empty
        self.collectionView.rx
            .startedDragging
            .withLatestFrom(self.viewModel.articles)
            .filter { (articles) -> Bool in
                return articles.count > 0
            }.subscribe(onNext: { [weak self] _ in
                self?.searchBar.endEditing(true)
            }).disposed(by: self.disposeBag)
        
        // Bind the placeholder appearance to the data source
        self.viewModel
            .articles
            .withLatestFrom(self.searchBar.rx.text) { (articles, query) -> String? in
                guard articles.count == 0 else { return nil }
                if query == "" { return NSLocalizedString("Search thousands of articles...", comment:"Search Placeholder Label Text")
                } else { return "No results found for '\(String(describing: query))'" }
            }.subscribe(onNext: { [weak self] (placeholderString) in
                self?.placeholderLabel.text = placeholderString
                UIView.animate(withDuration: 0.2) {
                    self?.placeholderView.alpha = placeholderString == nil ? 0.0 : 1.0
                    self?.collectionView.alpha = placeholderString == nil ? 1.0 : 0.0
                }
            }).disposed(by: self.disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


