//
//  RepositoriesAPI.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct RepositoriesAPI {
    
    private static let disposeBag = DisposeBag()
    
    static func searchRepositories(query query: String) -> Observable<[Repository]> {
        
        return RepositoriesNetworkService.searchRepositories(query: query)
    }
    
    
}