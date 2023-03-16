//
//  BasicCoordinator.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//

import RxSwift
import UIKit

protocol Coordinator: AnyObject {
    var identifier: String { get } //코디네이터를 식별하는 문자열
    var navigationController: UINavigationController { get set }
    var childCoordinators: [String: Coordinator] { get set } //자식 coordinator들을 identifier를 key로 하여 저장하는 딕셔너리
    var childCloseSignalDisposeBags: [String: [Disposable]] { get set }
    //자식 coordinator의 closeSignal을 처리하고 나오는 결과값인 Disposable을 리스트로 저장한다음, 해당 coordinator가 해제될 때 Disposable을 모두 dispose 해줌
    func release()
    func releaseChild(coordinator: Coordinator) //자식 coordinator 해제
}

class BasicCoordinator<CoordinatorResult>: Coordinator {
    // MARK: Lifecycle

    init(navController: UINavigationController) {
        navigationController = navController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    // MARK: Internal

    var identifier: String { "\(Self.self)" }
    var sceneDisposeBag = DisposeBag()

    var navigationController: UINavigationController

    var childCoordinators = [String: Coordinator]()
    var childCloseSignalDisposeBags = [String: [Disposable]]()

    /*
     특정 coordinator가 종료할 때, 종료했을 때의 결과를 이벤트로 전달하고, 부모 coordinator는 closeSignal을 옵저빙하고 있다가 이벤트가 들어오면 result에 따라 적절한 액션을 취함
     */
    var closeSignal = PublishSubject<CoordinatorResult>()

    /*
     자식 Coordinator를 생성하고 이를 화면에 표시할때 사용
     start -> 자식 Coordinator 시작
     
     */
    func coordinate<T>(coordinator: BasicCoordinator<T>, animated: Bool = true, needRelease: Bool = true, onCloseSignal: ((T) -> Void)? = nil) {
        let disposable = coordinate(coordinator: coordinator, animated: animated) //closeSignal
            .subscribe(onNext: { [weak self] coordResult in
                defer { //나중에 실행
                    if needRelease {
                        self?.releaseChild(coordinator: coordinator)
                    }
                }
                onCloseSignal?(coordResult)
            })

        addChildDisposable(id: coordinator.identifier, disposable: disposable)
    }

    @discardableResult
    private func coordinate<T>(coordinator: BasicCoordinator<T>, animated: Bool = true) -> Observable<T> {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start(animated: animated) //자식 coordinator 시작
        return coordinator.closeSignal
    }

    // 자식 coordinator의 closeSignal을 처리한 후, 나오는 결과값인 Disposable을 childCloseSignalBag에 저장한다음, 해제 시 해당 코디네이터의 Disposable을 해제할 수 있도록 함
    private func addChildDisposable(id: String, disposable: Disposable) {
        childCloseSignalDisposeBags[id, default: []].append(disposable)
    }

    func releaseChild(coordinator: Coordinator) {
        coordinator.release()
        let id = coordinator.identifier
        childCloseSignalDisposeBags[id]?.forEach { $0.dispose() }
        childCoordinators.removeValue(forKey: id)
        childCloseSignalDisposeBags.removeValue(forKey: id)
    }

    func release() { //자기 자신 해제
        childCoordinators.forEach { _, coord in coord.release() }
        childCloseSignalDisposeBags.flatMap { $1 }.forEach { $0.dispose() }
        childCoordinators.removeAll()
        childCloseSignalDisposeBags.removeAll()
    }

    func start(animated _: Bool) {
        fatalError("start() must be impl")
    }
}
