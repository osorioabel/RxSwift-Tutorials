//
//  FormValidationViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FormValidationViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var usernameTextField:UITextField!
    @IBOutlet weak private var passwordTextField:UITextField!
    @IBOutlet weak private var signInButton:UIButton!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configureTextFields()
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Form Validation"
    }
    
    private func configureTextFields(){
    
        let validEmail = usernameTextField.rx_text.map{ Validator.valid($0, inPattern: .email)}
        let validPassword = passwordTextField.rx_text.map{ Validator.valid($0, inPattern: .password)}
        let validForm = Observable.combineLatest(validEmail, validPassword){ (email,password) in
            return email && password
        }
        validForm.bindTo(signInButton.rx_enabled)
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - IBActions

}
