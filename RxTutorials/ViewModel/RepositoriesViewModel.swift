
//
//  RepositoriesViewModel.swift
//  RxTutorials
//
//  Created by Abel Osorio on 8/8/16.
//  Copyright © 2016 Abel Osorio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct RepositoriesViewModel {
    
    let searchText = Variable("")
    let disposeBag = DisposeBag()
    
    lazy var data:Driver<[Repository]> = {
        return self.searchText.asObservable()
            .filter{$0.characters.count > 0}
            .throttle(0.3,scheduler:MainScheduler.instance)
            .flatMapLatest{
                RepositoriesAPI.searchRepositories(query: $0).catchErrorJustReturn([])
            }.asDriver(onErrorJustReturn:[])
    }()

}