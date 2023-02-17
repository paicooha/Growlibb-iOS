//
//  EditPasswordFirstViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/15.
//

import Foundation
import RxSwift

final class EditPasswordFirstViewModel: BaseViewModel {
    
    var userInfo = UserInfo()

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()
        
        routeInputs.next
            .bind(to: routes.next)
            .disposed(by: disposeBag)
    
        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
        
        inputs.checkpassword
            .flatMap({
                myPageAPIService.postCheckPassword(request: $0)
            })
            .subscribe(onNext: { result in
                switch result {
                case let .response(result: result):
                    switch result!.code {
                    case 2013:
                        UserInfo.shared.email = ""
                        UserInfo.shared.phoneNumber = ""
                        //오류이므로 clear해주어야함
                        self.toast.onNext("존재하지 않는 회원입니다. 이메일 혹은 휴대폰 번호를 확인해주세요.")
                    case 1000:
                        self.routeInputs.next.onNext(()) //검증 성공 다음 화면으로 이동
                    default:
                        break
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self.toast.onNext(alertMessage)
                    } else {
                        self.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var checkpassword = PublishSubject<PostCheckPasswordRequest>()
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
        var next = PublishSubject<Void>()
    }

    struct RouteInput {
        var next = PublishSubject<Void>()
//        var filterChanged = PublishSubject<PostFilter>()
//        var detailClosed = PublishSubject<Void>()
//        var postListOrderChanged = PublishSubject<PostListOrder>()
//        var runningTagChanged = PublishSubject<RunningTag>()
//        var alarmChecked = PublishSubject<Void>()
    }

    var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
