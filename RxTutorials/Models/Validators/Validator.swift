//
//  Validator.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation

struct ValidationError: ErrorPresentable {
    var title: String?
    var message: String?
    
    init(title: String? = nil, message: String? = nil) {
        self.title = title
        self.message = message
    }
}

struct Validator {
    
    enum Pattern: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        case password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
    }
    
    static func valid(value: String, inPattern pattern: Pattern) -> Bool {
        return valid(value, inPattern: pattern.rawValue)
    }
    
    static func valid(value: String, inPattern pattern: String) -> Bool {
        let range = value.rangeOfString(pattern, options: .RegularExpressionSearch)
        return range != nil
    }
}