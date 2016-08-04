//
//  Button.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/12/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        layer.cornerRadius = 5.0
    }
    
}
