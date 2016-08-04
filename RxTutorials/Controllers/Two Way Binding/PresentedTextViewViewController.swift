//
//  PresentedTextViewViewController
//  RxTutorials
//
//  Created by Abel Osorio on 8/3/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift

class PresentedTextViewViewController: UIViewController, HasTwoWayBindingViewControllerViewModel {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    
    // HasTwoWayBindingViewControllerViewModel
    var viewModel: TwoWayBindingViewControllerViewModel!
    
    let disposeBag = DisposeBag()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        bindViewModel()
    }
    
    func bindViewModel() {
        
        viewModel.textViewText.asObservable()
            .bindTo(textView.rx_text)
            .addDisposableTo(disposeBag)
        
        textView.rx_text.subscribeNext{[weak self] in
            self?.viewModel.textViewText.value = $0
            }.addDisposableTo(disposeBag)
        
    }
    
}
