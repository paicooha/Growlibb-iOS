//
//  CSViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import RxSwift

final class CSViewModel: BaseViewModel {
    
    var doneCount = 1
    var keepCount = 1
    var problemCount = 1
    var tryCount = 1

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared)
    {
        super.init()
        
    }

    struct Input {

    }

    struct Output {

    }

    struct Route {

    }

    struct RouteInput {

    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
