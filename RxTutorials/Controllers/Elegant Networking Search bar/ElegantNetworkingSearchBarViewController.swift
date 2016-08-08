//
//  ElegantNetworkingSearchBarViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ElegantNetworkingSearchBarViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var searchBar:UISearchBar!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel:RepositoriesViewModel = RepositoriesViewModel()
    
    // MARK: - Lifecycle
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Elegant GitHub Repos"
        setUpNavigationBar()
        setUpSearchBar()
    }
    
    private func setUpNavigationBar(){
        
    }
    
    private func setUpSearchBar(){
        
        searchBar.placeholder = "Enter github username"
        
        searchBar.rx_text
            .filter{$0.characters.count > 0 }
            .bindTo(viewModel.searchText)
            .addDisposableTo(disposeBag)
        
        searchBar.rx_cancelButtonClicked
            .map{""}
            .bindTo(viewModel.searchText)
            .addDisposableTo(disposeBag)
        
        
        viewModel.data
            .drive(tableView.rx_itemsWithCellIdentifier("Cell")){ _, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url
            }.addDisposableTo(disposeBag)
    }
    
}
