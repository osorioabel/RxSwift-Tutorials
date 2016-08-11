//
//  RepositoriesNetworkService.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import RxAlamofire
import Alamofire

struct RepositoriesNetworkService {
    
    // driver way
    lazy var rx_repositories: Driver<[Repository]> = self.fetchRepositories()
    private var repositoryName: Observable<String>
    
    init(withNameObservable nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
    }
    
    private func fetchRepositories() -> Driver<[Repository]> {
        return repositoryName
            .subscribeOn(MainScheduler.instance) // Make sure we are on MainScheduler
            .doOn(onNext: { response in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            })
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMapLatest { text in // .Background thread, network request
                return RxAlamofire
                    .requestJSON(.GET, "https://api.github.com/users/\(text)/repos")
                    .catchError { error in
                        return Observable.never()
                }
            }
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .map { (response, json) -> [Repository] in // again back to .Background, map objects
                if let repos = Mapper<Repository>().mapArray(json) {
                    return repos
                } else {
                    return []
                }
            }
            .observeOn(MainScheduler.instance) // switch to MainScheduler, UI updates
            .doOn(onNext: { response in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: []) // This also makes sure that we are on MainScheduler
    }
    
    
    // Elegant way
    static func searchRepositories(query query:String) -> Observable<[Repository]>{
        
        return Observable.create{ (observer) -> Disposable in
            
            Alamofire.request(Router.Repositories(query))
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .Success(let jsonData):
                        
                        guard let repos: [Repository] =  Mapper<Repository>().mapArray(jsonData) else {
                            observer.onError(ApiError.defaultError)
                            break
                        }
                        observer.onNext(repos)
                        observer.onCompleted()
                    case .Failure(let error):
                        let apiError = ApiError(error: error, data:  response.data) ?? .defaultError
                        observer.onError(apiError)
                    }
            }
            return NopDisposable.instance
        }
    }
}