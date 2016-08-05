//
//  BasicControlsViewController.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/3/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasicControlsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var button: Button!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    
    @IBOutlet var valueChangedControls: [AnyObject]!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var skip = 1
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        print("Date :")
    }
    
    // MARK: - Internal Helpers
    
    private func setUpView(){
        title = "Basic View Controls"
        setUpTextFieldRxExample()
        setupTextViewRxExample()
        setUpButtonTapRxExample()
        setUpSegmentedControlRxExample()
        setUpSliderRxExample()
        setUpSwitchRxExample()
        setUpStepperRxExample()
        setUpDatePickerRxExample()
        setUpResetBarButton()
    }
    
    private func setUpTextFieldRxExample(){
        
        textField.rx_text.asDriver()
            .drive(textFieldLabel.rx_text)
            .addDisposableTo(disposeBag)
        
    }
    
    private func setupTextViewRxExample(){
        textView.rx_text.asDriver()
            .skip(skip)
            .driveNext{ [weak self] in
                self?.textViewLabel.rx_text.onNext("Character count:\($0.characters.count)")
            }
            .addDisposableTo(disposeBag)
    }
    
    private func setUpButtonTapRxExample(){
    
        button.rx_tap.asDriver()
            .driveNext{[weak self] in
            self?.buttonLabel.text! += "Tapped"
            self?.view.endEditing(true)
                UIView.animateWithDuration(0.3){self?.view.layoutIfNeeded()}
        }.addDisposableTo(disposeBag)
    }
    
    private func setUpSegmentedControlRxExample(){
        
        segmentedControl.rx_value.asDriver()
            .skip(skip)
            .driveNext{ [weak self] in
                self?.segmentedControlLabel.text! = "Selected value \($0)"
                UIView.animateWithDuration(0.3) { self?.view.layoutIfNeeded() }
            }.addDisposableTo(disposeBag)
    }
    
    private func setUpSliderRxExample(){
    
        slider.rx_value.asDriver()
            .driveNext{ [weak self] in
                self?.sliderLabel.text = "Slider value: \($0)"
            }.addDisposableTo(disposeBag)
        
        slider.rx_value.asDriver()
            .driveNext{ [weak self] in
                self?.progressView.progress = $0
        }.addDisposableTo(disposeBag)
    }
    
    private func setUpSwitchRxExample(){
    
        `switch`.rx_value.asDriver()
            .drive(activityIndicator.rx_animating)
            .addDisposableTo(disposeBag)
        
        `switch`.rx_value.asDriver()
            .map{ !$0}
            .drive(activityIndicator.rx_hidden)
            .addDisposableTo(disposeBag)
        
    }
    
    private func setUpStepperRxExample(){
    
        stepper.rx_value.asDriver()
            .map{ String(Int($0))}
            .driveNext{ [weak self] in
                self?.stepperLabel.text! = $0
            }.addDisposableTo(disposeBag)
    
    }
    
    private func setUpDatePickerRxExample(){
    
        datePicker.rx_date.asDriver()
            .map{ [weak self] in
                self?.dateFormatter.stringFromDate($0) ?? ""
            }.driveNext{ [weak self] in
                self?.datePickerLabel.text = "Selected date: \($0)"
            }.addDisposableTo(disposeBag)
    }
    
    private func setUpResetBarButton(){
        
        resetBarButtonItem.rx_tap.asDriver()
            .driveNext { [weak self] _ in
                guard let `self` = self else { return }
                self.textField.rx_text.onNext("")
                self.textView.rx_text.onNext("Text view")
                self.buttonLabel.rx_text.onNext("")
                self.skip = 0
                self.segmentedControl.rx_value.onNext(-1)
                self.segmentedControlLabel.text = ""
                self.slider.rx_value.onNext(0.5)
                self.`switch`.rx_value.onNext(false)
                self.stepper.rx_value.onNext(0.0)
                self.datePicker.setDate(NSDate(), animated: true)
                self.valueChangedControls.forEach { $0.sendActionsForControlEvents(.ValueChanged) }
                self.view.endEditing(true)
                UIView.animateWithDuration(0.3) { self.view.layoutIfNeeded() }
            }.addDisposableTo(disposeBag)
    
    }
    
    
    
    // MARK: - IBActions
    
}
