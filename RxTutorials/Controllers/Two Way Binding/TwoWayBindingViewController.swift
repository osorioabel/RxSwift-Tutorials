//
//  TwoWayBindingViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/4/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TwoWayBindingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    
    let viewModel = TwoWayBindingViewControllerViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Two Way Binding"
        button.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0).CGColor
        bindViewModel()
        
    }
    
    private func bindViewModel(){
        
        viewModel.textFieldText.asObservable()
            .bindTo(leftTextField.rx_text)
            .addDisposableTo(disposeBag)
        
        leftTextField.rx_text.subscribeNext{[weak self] in
            self?.viewModel.textFieldText.value = $0
        }.addDisposableTo(disposeBag)
        
        viewModel.textFieldText.asObservable()
            .bindTo(rightTextField.rx_text)
            .addDisposableTo(disposeBag)
        
        rightTextField.rx_text.subscribeNext{[weak self] in
            self?.viewModel.textFieldText.value = $0
            }.addDisposableTo(disposeBag)
        
        resetBarButtonItem.rx_tap.asDriver()
            .driveNext{ [weak self] in
                self?.viewModel.textFieldText.value = "Hello"
                self?.viewModel.textViewText.value = "Lorem ipsum dolor..."
        }.addDisposableTo(disposeBag)
        
        button.rx_tap.asDriver()
            .driveNext{[weak self] in
            self?.viewModel.textFieldText.value = "Button Tapped"
        }.addDisposableTo(disposeBag)
    }
    
    // MARK: - Navigation Related 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let  controller = (segue.destinationViewController as? UINavigationController)?.topViewController as? HasTwoWayBindingViewControllerViewModel else { return }
        controller.viewModel = viewModel
    }
    
    @IBAction func unwindToTwoWayBindingViewController(segue: UIStoryboardSegue) { }
    
    
    
}
