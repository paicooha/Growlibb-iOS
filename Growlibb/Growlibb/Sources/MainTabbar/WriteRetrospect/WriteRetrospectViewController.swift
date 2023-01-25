//
//  WriteRetrospectViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class WriteRetrospectViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        
        // 마지막에 이거 풀어야함
//        if !UserDefaults.standard.bool(forKey: "isPassedWriteRetrospectTutorial") {
            viewModel.inputs.showTutorial.onNext(())
//        }
    }

    init(viewModel: WriteRetrospectViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WriteRetrospectViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
    
    }

    private func viewModelOutput(){

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var navBar = NavBar().then { navBar in
        navBar.leftBtnItem.isHidden = false
        navBar.titleLabel.text = L10n.WriteRetrospect.title
    }
}

// MARK: - Layout

extension WriteRetrospectViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
}
