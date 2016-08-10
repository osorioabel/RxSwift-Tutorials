//
//  TutorialsListViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/2/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ChameleonFramework

class TutorialsListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var tableView:UITableView!
    
    // MARK: - Properties
    
    let dataSource = Observable.just(DataSource.values)
    let disposeBag = DisposeBag()
    
    // MARK: - Enums
    
    enum DataSource:String {
        
        case BasicControls = "BasicControlsViewController"
        case TwoWayBinding = "TwoWayBindingViewController"
        case SectionedTableViewReload = "SectionedTableViewReload"
        case SectionedTableViewAnimated = "SectionedTableViewAnimated"
        case BasicSearchBar = "BasicSearchBarViewController"
        case NetworkingSearchBar = "NetworkingSearchBarViewController"
        case ElegantNetworkingSearchBar = "ElegantNetworkingSearchBarViewController"
        case FormValidation = "FormValidationViewController"
        case Realm = "RealmJournalListViewController"
        case CoreData = "RxCoreDataJournalListViewController"
        
        static let values :[DataSource]  = [.BasicControls,.TwoWayBinding,.SectionedTableViewReload,.SectionedTableViewAnimated,.BasicSearchBar,.NetworkingSearchBar,.ElegantNetworkingSearchBar,.FormValidation,.Realm,.CoreData]
    }
    
    enum CellIdentifier:String {
        case textCellIdentifier = "TutorialList"
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Rx Examples"
        self.navigationController?.hidesNavigationBarHairline = true
        setUpTableView()
        
    }
    
    private func setUpTableView(){
        
        tableView.tableFooterView = UIView()
        
        dataSource.bindTo(tableView.rx_itemsWithCellIdentifier(CellIdentifier.textCellIdentifier.rawValue)) { row,element,cell in //bind datasources
            cell.textLabel?.text = String(element)
            cell.selectionStyle = .None
        }.addDisposableTo(disposeBag)
        
        tableView.rx_modelSelected(DataSource)
            .subscribeNext{ [weak self] in
                let nextVC = self?.storyboard?.instantiateViewControllerWithIdentifier($0.rawValue)
                self?.navigationController?.pushViewController(nextVC!, animated: true)
        }.addDisposableTo(disposeBag)
        
    }
    
}