//
//  WriteRetrospectViewModel.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import Foundation
import RxSwift

final class WriteRetrospectViewModel: BaseViewModel {

    init(
        loginKeyChainService: LoginKeyChainService = BasicLoginKeyChainService.shared
    ) {
        inputs.showTutorial
            .subscribe(routes.showTutorial)
            .disposed(by: disposeBag)
        
        inputs.backward
            .subscribe(routes.backward)
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var showTutorial = PublishSubject<Void>()
//        var showDetailFilter = PublishSubject<Void>()
//        var writingPost = PublishSubject<Void>()
//        var tapShowClosedPost = PublishSubject<Void>()
//        var tagChanged = PublishSubject<Int>()
//        var filterTypeChanged = PublishSubject<Int>()
//        var tapPostBookmark = PublishSubject<Int>()
//        var tapPostBookMarkWithId = PublishSubject<Int>()
//        var tapPost = PublishSubject<Int>()
//        var tapSelectedPost = PublishSubject<Void>()
//        var regionChanged = PublishSubject<(location: CLLocationCoordinate2D, radius: CLLocationDistance)>()
//        var moveRegion = PublishSubject<Void>()
//        var needUpdate = PublishSubject<Bool>()
//        var toHomeLocation = PublishSubject<Void>()
//        var tapPostPin = PublishSubject<Int?>()
//        var tapPostListOrder = PublishSubject<Void>()
//        var tapRunningTag = PublishSubject<Void>()
//
//        var tapAlarm = PublishSubject<Void>()
    }

    struct Output {
//        var posts = ReplaySubject<[Post]>.create(bufferSize: 1)
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
//        var filter = PublishSubject<PostFilter>()
//        var writingPost = PublishSubject<Void>()
//        var detailPost = PublishSubject<Int>()
//        var nonMemberCover = PublishSubject<Void>()
//        var postListOrder = PublishSubject<Void>()
//        var runningTag = PublishSubject<Void>()
        var backward = PublishSubject<Void>()
        var showTutorial = PublishSubject<Void>()
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
