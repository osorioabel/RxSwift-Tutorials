//
//  ApiError.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import Alamofire

protocol ErrorPresentable: ErrorType {
    var title: String? { get }
    var message: String? { get }
}

struct ApiError : ErrorPresentable  {
    
    // MARK: - Properties
    var title: String?
    var message: String?
    var code: ApiErrorCode?
    
    // MARK: - Initializers
    init(title: String? = nil, message: String? = nil, code: ApiErrorCode? = nil) {
        self.title = title
        self.message = message
        self.code = code
    }
    
    init?(error: NSError, data: NSData?) {
        
        if Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue) == error.code {
            title = LocalizableString.offlineError.localizedString
            message = LocalizableString.checkInternet.localizedString
        } else if let errorMessage = data?.apiErrorMessage {
            message = errorMessage
            if let code = data?.apiErrorCode, apiErrorCode = ApiErrorCode(rawValue: code) {
                self.code = apiErrorCode
            }
        } else {
            return nil
        }
    }
    
    // MARK: - Utils
    static var defaultError: ApiError {
        return ApiError(
            title: LocalizableString.connectionError.localizedString,
            message: LocalizableString.connectionProblem.localizedString,
            code: nil)
    }
}

enum ApiErrorCode: Int {
    // TODO: Set error Codes
    case ErrorUnknown = 0
    case sampleCase = 1
}

extension NSData {
    func toJSONDictionary() -> [String: AnyObject]? {
        
        guard let json = try? NSJSONSerialization.JSONObjectWithData(self, options: []) else {
            return nil
        }
        guard let jsonDic = json as? [String: AnyObject] else {
            return nil
        }
        return jsonDic
    }
    
    var apiErrorMessage: String? {
        if let jsonDic = toJSONDictionary(),
            let errorMessage = jsonDic["message"] as? String {
            return errorMessage
        }
        
        return nil
    }
    
    var apiErrorCode: Int? {
        if let jsonDic = toJSONDictionary(),
            let errorCode = jsonDic["code"] as? Int {
            return errorCode
        }
        
        return nil
    }
}



