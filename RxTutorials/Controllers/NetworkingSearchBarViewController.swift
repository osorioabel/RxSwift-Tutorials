//
//  NetworkingSearchBarViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NetworkingSearchBarViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var searchBar:UISearchBar!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoriesNetworkService!
    
    
    var searchText: Observable<String>{
        return  searchBar.rx_text
            .filter {$0.characters.count > 0}
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "GitHub Repos"
        setUpNavigationBar()
        setUpSearchBar()
        setupRx()
    }
    
    private func setUpNavigationBar(){
        
        tableView.tableFooterView = UIView()
    }
    
    private func setUpSearchBar(){
        
        searchBar.placeholder = "Enter github username"
       
    }
    
    func setupRx() {
        
        repositoryNetworkModel = RepositoriesNetworkService(withNameObservable: searchText)
        
        repositoryNetworkModel
            .rx_repositories
            .drive(tableView.rx_itemsWithCellFactory) { (tv, i, repository) in
                let cell = tv.dequeueReusableCellWithIdentifier("Cell", forIndexPath: NSIndexPath(forRow: i, inSection: 0))
                cell.textLabel?.text = repository.name
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        repositoryNetworkModel
            .rx_repositories
            .driveNext { repositories in
                if repositories.count == 0 {
                    print("No repositories")
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    
    
}
