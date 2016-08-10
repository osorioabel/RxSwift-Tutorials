//
//  RealmJournalViewController.swift
//  Journal
//
//  Created by Abel Osorio on 8/9/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class RealmJournalViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var notesTextView: UITextView!
    
    
    // MARK: - Properties
    let realm = try! Realm()
    var journal: RealmJournal!
    let disposeBag = DisposeBag()
    var textViewText = Variable("")
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(RealmJournalViewController.saveChanges))
        navigationItem.rightBarButtonItem = saveButton
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = journal.notes.isEmpty ? "Create" : "Edit"
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(RxCoreDataJournalViewController.saveChanges))
        navigationItem.rightBarButtonItem = saveButton
        textViewText.value = journal.notes
        setUpTextView()
        
    }
    
    private func setUpTextView(){
        
        textViewText.asObservable()
            .bindTo(notesTextView.rx_text)
            .addDisposableTo(disposeBag)
        
        notesTextView.rx_text.subscribeNext{[weak self] in
            self?.textViewText.value = $0
            }.addDisposableTo(disposeBag)
        
        notesTextView.becomeFirstResponder()
    }
    
    func saveChanges() {
        
        realm.beginWrite()
        journal.notes = textViewText.value
        realm.add(journal,update: true)
        do{
            try realm.commitWrite()
            navigationController?.popViewControllerAnimated(true)
        }catch{
            print("Error")
        }
    }
}
