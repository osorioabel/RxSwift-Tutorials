//
//  LocalizableString.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
enum LocalizableString: String {
    
    var localizedString: String {
        return NSLocalizedString(rawValue, comment: "")
    }
    
    //MARK: - Global
    case connectionError = "Connection error"
    case connectionProblem = "There was a problem, please try again."
    case offlineError = "Offline error"
    case checkInternet = "Check your internet connection and try again."
    
    case emailInvalid = "Please enter emails in the valid format."
    case emailMandatory = "Email field is mandatory."
    case passwordInvalid = "Password contains invalid characters."
    case passwordMandatory = "Password field is mandatory."
    case passwordMatch = "Passwords don’t match."
    case completeAllFields = "Please complete all fields."
    
}