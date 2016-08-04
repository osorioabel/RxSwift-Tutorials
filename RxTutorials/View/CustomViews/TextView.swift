//
//  TextView.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/21/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

class TextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0).CGColor
    }
    
}
