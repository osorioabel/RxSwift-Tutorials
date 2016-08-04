//
//  AnimatedDataSourceViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/4/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

struct AnimatedSectionModel {
    
    let title: String
    var dataSourceItems: [String]
    
}

extension AnimatedSectionModel: AnimatableSectionModelType {
    
    typealias Item = String
    typealias Identity = String
    
    var identity: Identity { return title }
    var items: [Item] { return dataSourceItems }
    
    init(original: AnimatedSectionModel, items: [String]) {
        self = original
        dataSourceItems = items
    }
    
}

class AnimatedDataSourceViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var addBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatedSectionModel>()
    let data = Variable([AnimatedSectionModel(title: "Section 1", dataSourceItems: ["Sample Data 1-1", "Sample Data 1-2"])])
    let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Animated DataSource "
        setUpTableView()
        
    }
    
    private func setUpTableView(){
        
        tableView.tableFooterView = UIView()
        
        dataSource.configureCell = { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel!.text = item
            return cell
        }
        
        data.asDriver()
            .drive(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.titleForHeaderInSection = {
            $0.sectionAtIndex($1).title
        }
        
        addBarButtonItem.rx_tap.asDriver()
            .driveNext { [weak self] _ in
                guard let strongSelf = self else { return }
                let index = strongSelf.data.value.count + 1
                strongSelf.data.value += [AnimatedSectionModel(title: "Section \(index)", dataSourceItems: ["Sample Data \(index)-1", "Sample Data \(index)-2"])]
            }
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - IBActions

}
