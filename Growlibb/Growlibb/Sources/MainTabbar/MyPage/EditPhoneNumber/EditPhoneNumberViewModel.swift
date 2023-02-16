//
//  EditPhoneNumberViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/14.
//

import Foundation
import RxSwift

final class EditPhoneNumberViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()
        
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
        
        inputs.newPhone
            .flatMap { myPageAPIService.patchPhoneNumber(request: PostCheckPhoneRequest(phoneNumber: $0))}
            .subscribe(onNext: { result in
                switch result {
                case let .response(result: result):
                    switch result!.code {
                    case 2022:
                        self.toast.onNext("이미 사용중인 휴대폰 번호입니다. 다른 번호로 시도해주세요.")
                    case 1000:
                        self.toast.onNext("휴대폰번호 변경이 완료되었습니다.")
                        self.routes.backward.onNext(())
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
        var newPhone = PublishSubject<String>()
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
