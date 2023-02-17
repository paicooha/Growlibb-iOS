//
//  EditPasswordViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/13.
//

import Foundation
import RxSwift

final class EditPasswordSecondViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()
        
        inputs.modify
            .flatMap {  myPageAPIService.patchPassword(request: PatchPasswordRequest(phoneNumber: $0.phoneNumber, email: $0.email, password: $0.password, confirmPassword: $0.password)) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(result: result):
                    switch result!.code {
                    case 1000:
                        self?.toast.onNext("비밀번호가 성공적으로 변경되었습니다.")
                        self?.routes.goMyPage.onNext(())
                    default:
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
            })
            .disposed(by: disposeBag)
        
//        routeInputs.needUpdate
//            .flatMap { _ in
//                myPageAPIService.getMyPage()
//            }
//            .subscribe(onNext: { [weak self] result in
//                switch result {
//                case let .response(result: result):
//                    self?.outputs.mypage.onNext(result!)
//                case let .error(alertMessage):
//                    if let alertMessage = alertMessage {
//                        self?.toast.onNext(alertMessage)
//                    } else {
//                        self?.toast.onNext("데이터 불러오기에 실패했습니다.")
//                    }
//                }
//                self?.outputs.mypagelist.onNext(self!.myPageList)
//            })
//            .disposed(by: disposeBag)
        inputs.backward
            .bind(to: routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var modify = PublishSubject<UserInfo>()
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
        var goMyPage = PublishSubject<Void>()
    }

    struct RouteInput {
//        var needUpdate = PublishSubject<Bool>()
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
