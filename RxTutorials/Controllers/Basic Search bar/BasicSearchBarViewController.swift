//
//  BasicSearchBarViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/4/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BasicSearchBarViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var searchBar:UISearchBar!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var shownCities = Observable.just(["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga","New Delhi"])
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Basic Searchbar"
        setUpTableView()
        setUpSearchBar()
    }
    
    private func setUpTableView(){
        
        
    }
    
    private func setUpSearchBar(){
        
        searchBar.placeholder = "Enter cities name"
        
        let searchResults = searchBar.rx_text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[String]> in
                if query.isEmpty {
                    return self.shownCities
                }
                return self.shownCities.flatMap{$0.toObservable()}
                    .filter{$0.hasPrefix(query)}
                    .toArray()
            }
            .observeOn(MainScheduler.instance)
        
        searchResults.bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) { row,element,cell in //bind datasources
            cell.textLabel?.text = String(element)
            cell.selectionStyle = .None
            }.addDisposableTo(disposeBag)
        
    }
    
    // MARK: - IBActions
    
}
