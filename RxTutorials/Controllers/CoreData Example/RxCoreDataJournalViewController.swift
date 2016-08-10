//
//  RxCoreDataJournalViewController.swift
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

class RxCoreDataJournalViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var notesTextView: UITextView!
    
    // MARK: - Properties
    var journalEntry: Journal!
    var context: NSManagedObjectContext!
    let disposeBag = DisposeBag()
    var textViewText = Variable("")
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = journalEntry.notes.isEmpty ? "Create" : "Edit"
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(RxCoreDataJournalViewController.saveChanges))
        navigationItem.rightBarButtonItem = saveButton
        textViewText.value = journalEntry.notes
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
        journalEntry.notes = textViewText.value
        do {
            try context.update(journalEntry)
            navigationController?.popViewControllerAnimated(true)
        } catch {
            print("Something went wrong!")
        }
    }
    
}
