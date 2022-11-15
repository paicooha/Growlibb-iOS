//
//  MainTabbarViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import Foundation
import RxSwift

final class MainTabViewModel: BaseViewModel {
    var loginKeyChainService: LoginKeyChainService

    init(loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared) {
        self.loginKeyChainService = loginKeyChainService
        super.init()
        outputs.loginType = loginKeyChainService.loginType

        Observable.of(loginKeyChainService.loginType)
            .subscribe(onNext: { [weak self] loginType in
                switch loginType {
                case .nonMember:
                    break
                case .member:
                    break
                }
            })
            .disposed(by: disposeBag)

        inputs.homeSelected
            .subscribe(onNext: { [weak self] in
                self?.changeSceneIfMember(to: 0)
            })
            .disposed(by: disposeBag)

        inputs.retrospectSelected
            .subscribe(onNext: { [weak self] in
                self?.changeSceneIfMember(to: 1)
            })
            .disposed(by: disposeBag)

        inputs.myPageSelected
            .subscribe(onNext: { [weak self] in
                self?.changeSceneIfMember(to: 2)
            })
            .disposed(by: disposeBag)

        routeInputs.toHome
            .map { 0 }
            .bind(to: outputs.selectScene)
            .disposed(by: disposeBag)
    }

    private func changeSceneIfMember(to index: Int) {
        outputs.selectScene.onNext(index)
        switch index {
            case 0:
                routes.home.onNext(())
            case 1:
                routes.retrospect.onNext(())
            case 2:
                routes.myPage.onNext(())
            default:
                break
        }
    }

    struct Input { // View에서 ViewModel로 전달되는 이벤트가 있을때의 구조체
        var homeSelected = PublishSubject<Void>()
        var retrospectSelected = PublishSubject<Void>()
        var myPageSelected = PublishSubject<Void>()
    }

    struct Output { // ViewModel에서 View로 전달되는 이벤트가 있을때의 구조체
        var loginType: LoginType = .nonMember
        var selectScene = PublishSubject<Int>()
    }

    struct Route { // 화면 전환 이벤트를 coordinator에 전달하는 구조체
        var home = PublishSubject<Void>()
        var retrospect = PublishSubject<Void>()
        var myPage = PublishSubject<Void>()
    }

    struct RouteInput { // 자식 화면이 해제될때 (ex. 뒤로가기) 전달해야할 정보가 있을 경우, 해당 이벤트가 정의되어있는 구조체
        var toHome = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}
