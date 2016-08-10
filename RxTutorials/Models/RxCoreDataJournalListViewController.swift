//
//  RxCoreDataJournalListViewController.swift
//  Journal
//
//  Created by Abel Osorio on 8/9/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import RxDataSources
import RxCoreData
import BNRCoreDataStack

class RxCoreDataJournalListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView:UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var coreDataStack: CoreDataStack!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "RxCoreData"
        CoreDataStack.constructSQLiteStack(withModelName: "JournalModel") { (result) in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
            case .Failure(let error):
                print(error)
            }
        }
        setUpTableView()
    }
    
    func addJournalEntry() {
        let rxCoreDataJournalVC = self.storyboard?.instantiateViewControllerWithIdentifier("RxCoreDataJournalViewController") as! RxCoreDataJournalViewController
        let journalEntry: Journal
        journalEntry = Journal(id: NSUUID().UUIDString, date: NSDate(), notes: "")
        rxCoreDataJournalVC.journalEntry = journalEntry
        rxCoreDataJournalVC.context = coreDataStack.newChildContext()
        self.navigationController?.pushViewController(rxCoreDataJournalVC, animated: true)
    }
    
    func editJournal(journal:Journal){
        let rxCoreDataJournalVC = self.storyboard?.instantiateViewControllerWithIdentifier("RxCoreDataJournalViewController") as! RxCoreDataJournalViewController
        rxCoreDataJournalVC.journalEntry = journal
        rxCoreDataJournalVC.context = coreDataStack.newChildContext()
        self.navigationController?.pushViewController(rxCoreDataJournalVC, animated: true)
    }
    
    private func setUpTableView(){
        
        tableView.tableFooterView = UIView()
        
        coreDataStack.mainQueueContext.rx_entities(Journal.self, sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
            .bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) { row, journal, cell in
                cell.detailTextLabel?.text = "\(journal.date)"
                cell.textLabel?.text = "\(journal.notes)"
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .map{ [unowned self] indexPath in
                try self.tableView.rx_modelAtIndexPath(indexPath) as Journal
            }.subscribeNext{ [unowned self] selectedJournal in
                self.editJournal(selectedJournal)
            }.addDisposableTo(disposeBag)
        
        tableView.rx_itemDeleted
            .map { [unowned self] indexPath in
                try self.tableView.rx_modelAtIndexPath(indexPath) as Journal
            }
            .subscribeNext { [unowned self] deletedJournal in
                _ = try? self.coreDataStack.mainQueueContext.delete(deletedJournal)
            }
            .addDisposableTo(disposeBag)
    }
    
}
