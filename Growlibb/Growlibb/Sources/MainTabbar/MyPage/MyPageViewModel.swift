//
//  MyViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation
import RxSwift

final class MyPageViewModel: BaseViewModel {
    
    var myPageList = [L10n.MyPage.List.retrospect, L10n.MyPage.List.editProfile, L10n.MyPage.List.editPassword, L10n.MyPage.List.editPhone, L10n.MyPage.List.editNoti, L10n.MyPage.Cs.title, L10n.MyPage.List.logout, L10n.MyPage.List.resign]

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared, userKeyChainService:UserKeychainService = BasicUserKeyChainService.shared,
        myPageAPIService: MyPageAPIService = MyPageAPIService()
    ) {
        super.init()
        
        routeInputs.needUpdate
            .flatMap { _ in
                myPageAPIService.getMyPage()
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .response(result: result):
                    self?.outputs.mypage.onNext(result!)
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("데이터 불러오기에 실패했습니다.")
                    }
                }
                self?.outputs.mypagelist.onNext(self!.myPageList)
            })
            .disposed(by: disposeBag)
        
        routeInputs.goLogin
            .flatMap { _ in
                myPageAPIService.logout()
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .response(result: _):
                    loginKeyChainService.clear() //정보 clear
                    userKeyChainService.clear()
                    self?.routes.goLogin.onNext(()) //로그아웃 성공 시 로그인 화면 이동
                case let .error(alertMessage):
                    if let alertMessage = alertMessage {
                        self?.toast.onNext(alertMessage)
                    } else {
                        self?.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                    }
                }
                self?.outputs.mypagelist.onNext(self!.myPageList)
            })
            .disposed(by: disposeBag)
        
        inputs.editProfile
            .bind(to: routes.editProfile)
            .disposed(by: disposeBag)
        
        inputs.editPassword
            .bind(to: routes.editPassword)
            .disposed(by: disposeBag)
        
        inputs.editPhoneNumber
            .bind(to: routes.editPhoneNumber)
            .disposed(by: disposeBag)
        
        inputs.editNoti
            .bind(to: routes.editNoti)
            .disposed(by: disposeBag)
        
        inputs.goCS
            .bind(to: routes.goCS)
            .disposed(by: disposeBag)
        
        inputs.logout
            .bind(to: routes.logout)
            .disposed(by: disposeBag)
        
        inputs.goResign
            .bind(to: routes.goResign)
            .disposed(by: disposeBag)
        
        inputs.goRetrospectList
            .bind(to: routes.goRetrospectList)
            .disposed(by: disposeBag)
        
    }

    struct Input {
        var logout = PublishSubject<Void>()
        var goCS = PublishSubject<Void>()
        var editProfile = PublishSubject<Void>()
        var editPassword = PublishSubject<Void>()
        var editPhoneNumber = PublishSubject<Void>()
        var editNoti = PublishSubject<Void>()
        var goResign = PublishSubject<Void>()
        var goRetrospectList = PublishSubject<Void>()
    }

    struct Output {
        var mypage = ReplaySubject<MyPage>.create(bufferSize: 1)
        var mypagelist = ReplaySubject<[String]>.create(bufferSize: 1)
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
        var goCS = PublishSubject<Void>()
        var editProfile = PublishSubject<Void>()
        var editPassword = PublishSubject<Void>()
        var editPhoneNumber = PublishSubject<Void>()
        var editNoti = PublishSubject<Void>()
        var goResign = PublishSubject<Void>()
        var logout = PublishSubject<Void>()
        var goLogin = PublishSubject<Void>()
        var goRetrospectList = PublishSubject<Void>()
    }

    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
        var goLogin = PublishSubject<Bool>()
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
