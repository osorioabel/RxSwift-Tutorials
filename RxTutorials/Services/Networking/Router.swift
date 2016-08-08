//
//  Router.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import Alamofire

typealias JSONDictionary = [String: AnyObject]


enum Router: URLRequestConvertible {
    
    private struct Request {
        let method: Alamofire.Method
        let path: String
        let encoding: ParameterEncoding?
        let parameters: JSONDictionary?
        
        init(method: Alamofire.Method,
             path: String,
             encoding: ParameterEncoding? = nil,
             parameters: JSONDictionary? = nil){
            
            self.method = method
            self.path = path
            self.encoding = encoding
            self.parameters = parameters
        }
    }
    
    static let baseHostPath = "https://api.github.com/"
    
    var baseURLPath: String {
        
        switch self {
        default:
            return "\(Router.baseHostPath)"
        }
    }
    
    case Repositories(String)
    
    private var request: Request {
        switch self {
        //Repositories
        case .Repositories(let query):
            return Request(method: .GET,
                           path: "users/\(query)/repos",
                           encoding: .JSON)
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let URL = NSURL(string: baseURLPath)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(request.path))
        mutableURLRequest.HTTPMethod = request.method.rawValue
        mutableURLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
        
        if let encoding = request.encoding {
            return encoding.encode(mutableURLRequest, parameters: request.parameters).0
        } else {
            return mutableURLRequest
        }
    }
}