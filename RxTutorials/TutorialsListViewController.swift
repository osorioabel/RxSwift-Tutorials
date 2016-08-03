//
//  TutorialsListViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/2/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit

class TutorialsListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var tableView:UITableView!
    
    // MARK: - Properties
    
    var rxTutorials:[String] = ["Basic Operators"]
    
    // MARK: - Enum
    
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
        setUpTableView()
        self.navigationController?.hidesNavigationBarHairline = true
    }
    
    private func setUpTableView(){
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBActions

}

extension TutorialsListViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.textCellIdentifier.rawValue, forIndexPath: indexPath)
        cell.textLabel?.text = rxTutorials[indexPath.row]
        return cell
    }
    

}
