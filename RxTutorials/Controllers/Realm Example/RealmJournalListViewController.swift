//
//  RealmJournalListViewController.swift
//  Journal
//
//  Created by Abel Osorio on 8/9/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift
import RxRealm

class RealmJournalListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let realm = try! Realm()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Realm Journal"
        setUpTableView()
        setUpBarButton()
    }
    
    
    private func setUpTableView(){
        
        tableView.tableFooterView = UIView()
        
        realm.objects(RealmJournal).sorted("date", ascending: false).asObservableArray()
            .bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) {row, journal, cell in
                cell.detailTextLabel?.text = "\(journal.date)"
                cell.textLabel?.text = "\(journal.notes)"
            }.addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .map{ [unowned self] indexPath in
                try self.tableView.rx_modelAtIndexPath(indexPath) as RealmJournal
            }.subscribeNext{ [unowned self] selectedJournal in
                self.editJournal(selectedJournal)
            }.addDisposableTo(disposeBag)
        
        tableView.rx_itemDeleted
            .map { [unowned self] indexPath in
                try self.tableView.rx_modelAtIndexPath(indexPath) as RealmJournal
            }
            .subscribeNext { deletedJournal in
                [deletedJournal].toObservable()
                .subscribe(Realm.rx_delete())
            }
            .addDisposableTo(disposeBag)
    }
    
    func setUpBarButton(){
        
        addButton.rx_tap.asDriver()
            .driveNext{[weak self] in
                self?.addJournalEntry()
            }.addDisposableTo(disposeBag)
    }
    
    func addJournalEntry() {
        let realmJournalVC = self.storyboard?.instantiateViewControllerWithIdentifier("RealmJournalViewController") as! RealmJournalViewController
        let journalEntry = RealmJournal()
        realmJournalVC.journal = journalEntry
        self.navigationController?.pushViewController(realmJournalVC, animated: true)
        
    }
    
    func editJournal(journal:RealmJournal){
        let realmJournalVC = self.storyboard?.instantiateViewControllerWithIdentifier("RealmJournalViewController") as! RealmJournalViewController
        realmJournalVC.journal = journal
        self.navigationController?.pushViewController(realmJournalVC, animated: true)
        
    }

}
