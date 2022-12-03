//
//  MainTabbarController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/09.
//
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import SwiftUI
import Then
import UIKit

class MainTabViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()

        showSelectedVC(at: 0)
    }

    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MainTabViewModel

    private func viewModelInput() {
        homeBtn.rx.tapGesture()
            .when(.recognized)
            .map { _ in
                self.retrospectLabel.textColor = .brownGray
                self.homeLabel.textColor = .primaryBlue
                self.myPageLabel.textColor = .brownGray
            }
            .subscribe(viewModel.inputs.homeSelected)
            .disposed(by: disposeBag)

        retrospectBtn.rx.tapGesture()
            .when(.recognized)
            .map { [self] _ in
                self.retrospectLabel.textColor = .primaryBlue
                self.homeLabel.textColor = .brownGray
                self.myPageLabel.textColor = .brownGray
            }
            .subscribe(viewModel.inputs.retrospectSelected)
            .disposed(by: disposeBag)

        myPageBtn.rx.tapGesture()
            .when(.recognized)
            .map { _ in
                self.retrospectLabel.textColor = .brownGray
                self.homeLabel.textColor = .brownGray
                self.myPageLabel.textColor = .primaryBlue
            }
            .subscribe(viewModel.inputs.myPageSelected)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.selectScene
            .subscribe(onNext: { [weak self] index in
                self?.tabSelected(at: index)
                self?.showSelectedVC(at: index)
            })
            .disposed(by: disposeBag)
        
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private func showSelectedVC(at index: Int) {
        guard index < viewControllers.count else { return }

        for (idx, viewController) in viewControllers.enumerated() {
            if idx == index {
                viewController.view.isHidden = false
            } else {
                viewController.view.isHidden = true
            }
        }

        if !mainContentView.subviews.contains(where: { $0 == viewControllers[index].view }) {
            mainContentView.addSubview(viewControllers[index].view)
            viewControllers[index].view.snp.makeConstraints { make in
                make.top.equalTo(mainContentView.snp.top)
                make.leading.equalTo(mainContentView.snp.leading)
                make.trailing.equalTo(mainContentView.snp.trailing)
                make.bottom.equalTo(mainContentView.snp.bottom)
            }
        }
    }

    private func tabSelected(at index: Int) {
        guard index < 4 else { return }

        homeBtn.isSelected = false
        retrospectBtn.isSelected = false
        myPageBtn.isSelected = false

        switch index {
        case 0:
            homeBtn.isSelected = true
        case 1:
            retrospectBtn.isSelected = true
        case 2:
            myPageBtn.isSelected = true
        default:
            break
        }
    }

    var viewControllers: [UIViewController] = []

    private var mainContentView = UIView().then { view in
        view.backgroundColor = .white
    }

    private var bottomView = UIView().then { view in
        view.backgroundColor = .white
    }

    private var homeBtn = UIButton().then { button in
        button.setImage(Asset.icHomeGray.image, for: .normal)
        button.setImage(Asset.icHomeBlue.image, for: .selected)
        button.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
    }
    
    private var homeLabel = UILabel().then { make in
        make.text = L10n.Main.HomeTab.title
        make.font = .pretendardMedium12
        make.textColor = .primaryBlue
    }
    
    private lazy var homeTabVStack = UIStackView.make(
        with: [homeBtn, homeLabel],
        axis: .vertical,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 5
    )

    private var retrospectBtn = UIButton().then { button in
        button.setImage(Asset.icRetrospectGray.image, for: .normal)
        button.setImage(Asset.icRetrospectBlue.image, for: .selected)
        button.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
    }
    
    private var retrospectLabel = UILabel().then { make in
        make.text = L10n.Main.RetrospectTab.title
        make.font = .pretendardMedium12
    }
    
    private lazy var retrospectTabVStack = UIStackView.make(
        with: [retrospectBtn, retrospectLabel],
        axis: .vertical,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 5
    )

    private var myPageBtn = UIButton().then { button in
        button.setImage(Asset.icMyGray.image, for: .normal)
        button.setImage(Asset.icMyBlue.image, for: .selected)
        button.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
    }
    
    private var myPageLabel = UILabel().then { make in
        make.text = L10n.Main.MyPage.title
        make.font = .pretendardMedium12
    }
    
    private lazy var myPageTabVStack = UIStackView.make(
        with: [myPageBtn, myPageLabel],
        axis: .vertical,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 5
    )

    private lazy var bottomContentHStack = UIStackView.make(
        with: [homeTabVStack, retrospectTabVStack, myPageTabVStack],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 0
    )
}

// MARK: - Layout

extension MainTabViewController {
    private func setupViews() {
        homeBtn.isSelected = true

        view.addSubviews([
            mainContentView,
            bottomView,
        ])

        bottomView.addSubviews([bottomContentHStack])
    }

    private func initialLayout() {
        mainContentView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(mainContentView.snp.bottom)
            make.leading.equalTo(mainContentView.snp.leading)
            make.trailing.equalTo(mainContentView.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(AppContext.shared.tabHeight + AppContext.shared.safeAreaInsets.bottom)
        }

        bottomContentHStack.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(14)
            make.leading.equalTo(bottomView.snp.leading).offset(36)
            make.trailing.equalTo(bottomView.snp.trailing).offset(-36)
        }

        homeTabVStack.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
        }

        retrospectTabVStack.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
        }

        myPageTabVStack.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
        }
    }
}
