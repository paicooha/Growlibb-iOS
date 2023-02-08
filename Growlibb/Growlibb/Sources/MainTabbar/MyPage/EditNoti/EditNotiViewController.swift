//
//  EditNotiViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/06.
//

import Foundation
import UIKit

class EditNotiViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: EditViewModel

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
        navBar.rightBtnItem.isHidden = true
        navBar.titleLabel.isHidden = false
        navBar.titleLabel.text = L10n.MyPage.editNoti
    }
}

// MARK: - Layout

extension EditNotiViewController {
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
