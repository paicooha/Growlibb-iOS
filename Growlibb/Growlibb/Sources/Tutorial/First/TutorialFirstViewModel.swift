//
//  TutorialViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/08.
//

import Foundation
import RxSwift

final class TutorialFirstViewModel: BaseViewModel {
    override init() {
        super.init()

        inputs.tapNext
            .subscribe(routes.next)
            .disposed(by: disposeBag)
    }

    // MARK: Internal

    struct Input {
        var tapNext = PublishSubject<Void>() //View -> ViewModel
    }

    struct Output { //ViewModel -> View
    }

    struct Route { //화면전환이 필요한 경우 이벤트를 Coordinator에 전달
        var next = PublishSubject<Void>()
    }
    
    struct RouteInput { //child 화면이 해제되었을 때 전달해야할 정보가 있을 경우 전달할 이벤트가 정의되어있는 구조체 (ex. 화면이나 데이터를 업데이트해야하는 경우)

    }

    var inputs = Input()
    var outputs = Output()
    var routes = Route()

    // MARK: Private

    private var disposeBag = DisposeBag()
}
