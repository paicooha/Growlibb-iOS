//
//  ResignViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import Foundation
import RxSwift

final class ResignViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        userKeyChainService:UserKeychainService = BasicUserKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()
        
        inputs.resign
            .flatMap { myPageAPIService.resign(request: ResignReason(reason: $0))}
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .response(result: _):
                    loginKeyChainService.clear() //정보 clear
                    userKeyChainService.clear()
                    self?.routes.modal.onNext(()) //회원탈퇴 성공 시 회원탈퇴 모달 띄우기
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var resign = PublishSubject<String>()
        var backward = PublishSubject<Void>()
    }

    struct Output {
//        var mypage = ReplaySubject<MyPage>.create(bufferSize: 1)
//        var mypagelist = ReplaySubject<[String]>.create(bufferSize: 1)
//        var refresh = PublishSubject<Void>()
//        var bookMarked = PublishSubject<(id: Int, marked: Bool)>()
//        var highLightFilter = PublishSubject<Bool>()
//        var showClosedPost = PublishSubject<Bool>()
//        var showRefreshRegion = PublishSubject<Bool>()
//        var changeRegion = ReplaySubject<(location: CLLocationCoordinate2D, distance: CLLocationDistance)>.create(bufferSize: 1)
//        var focusSelectedPost = PublishSubject<Post?>()
//        var postListOrderChanged = PublishSubject<PostListOrder>()
//        var runningTagChanged = PublishSubject<RunningTag>()
//        var titleLocationChanged = PublishSubject<String?>()
//        var alarmChecked = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var modal = PublishSubject<Void>()
        var goLogin = PublishSubject<Void>()
    }

    struct RouteInput {
        var goLogin = PublishSubject<Bool>()

    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
