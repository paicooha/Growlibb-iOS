//
//  CSViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class CSViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: CSViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: CSViewModel

    private func viewModelInput() {
    }

    private func viewModelOutput(){

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var navBar = NavBar().then { navBar in
        navBar.rightBtnItem.isHidden = false
        navBar.titleLabel.isHidden = false
//        navBar.titleLabel.text = L10n.My
    }
    
    private var tableView = UITableView().then { view in
        view.isScrollEnabled = false
        view.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.id)
    }
}

// MARK: - Layout

extension CSViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            tableView
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
