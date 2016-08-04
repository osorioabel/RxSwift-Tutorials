//
//  TwoWayBindingViewControllerViewModel.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/4/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HasTwoWayBindingViewControllerViewModel: class {
    
    var viewModel: TwoWayBindingViewControllerViewModel! { get set }
}

class TwoWayBindingViewControllerViewModel {
    
    var textFieldText = Variable("Hello")
    var textViewText = Variable("Lorem ipsum dolor...")
    
}