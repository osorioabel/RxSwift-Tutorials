//
//  ReloadDataSourceViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/4/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

enum ReloadDataSource: String {
    
    case SampleData1 = "Sample Data 1"
    case SampleData2 = "Sample Data 2"
    
    static let allValues: [ReloadDataSource] = [.SampleData1, .SampleData2]
    
}

extension ReloadDataSource: IdentifiableType {
    
    var identity: String { return rawValue }
    
}

class ReloadDataSourceViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var addBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,ReloadDataSource>>()
    let data = Variable([SectionModel(model:"Section 1",items:ReloadDataSource.allValues)])
    let disposeBag = DisposeBag()
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Reload Datasource"
        setUpTableView()
    }
    
    private func setUpTableView(){
        
        tableView.tableFooterView = UIView()
        
        dataSource.configureCell = { _ , tableView, indexPath, dataSourceItem in
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
            cell.textLabel?.text = dataSourceItem.rawValue
            return cell
        }
        
        dataSource.titleForHeaderInSection = {
            $0.sectionAtIndex($1).model
        }
        
        addBarButtonItem.rx_tap.asDriver()
            .driveNext{ [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.data.value += [SectionModel(model:"Section \(strongSelf.data.value.count + 1)",items:ReloadDataSource.allValues)]
            }.addDisposableTo(disposeBag)
        
        data.asDriver()
            .drive(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - IBActions
    
}
