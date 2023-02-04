//
//  MyPageViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MyPageViewController: BaseViewController {
    
    var myPageList = [L10n.MyPage.List.retrospect, L10n.MyPage.List.editProfile, L10n.MyPage.List.editPassword, L10n.MyPage.List.editPhone, L10n.MyPage.List.editNoti, L10n.MyPage.List.logout, L10n.MyPage.List.resign]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MyPageViewModel

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
        navBar.titleLabel.isHidden = true
    }
    
    private var scrollView = UIScrollView().then { view in
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var profile = UIImageView().then { view in
        view.image = Asset.icMyProfile.image
    }
    
    private var nickname = UILabel().then { view in
        view.font = .pretendardSemibold18
        
    }
    
    private var seedlevelLabel = UILabel().then { view in
        view.font = .pretendardSemibold18
        view.textColor = .primaryBlue
    }
    
    private var seedTitleLabel = UILabel().then { view in
        view.font = .pretendardRegular12
        view.text = L10n.MyPage.SeedLevel.title
    }
    
    private lazy var seedVStack = UIStackView.make(
        with: [seedlevelLabel, seedTitleLabel],
        axis: .vertical,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 9
    )

    
    private var pointLabel = UILabel().then { view in
        view.font = .pretendardSemibold18
        view.textColor = .primaryBlue
    }
    
    private var pointTitleLabel = UILabel().then { view in
        view.font = .pretendardRegular12
        view.text = L10n.MyPage.Point.title
    }
    
    private lazy var pointVStack = UIStackView.make(
        with: [pointLabel, pointTitleLabel],
        axis: .vertical,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 9
    )
    
    private var retrospectLabel = UILabel().then { view in
        view.font = .pretendardSemibold18
        view.textColor = .primaryBlue
    }
    
    private var retrospectTitleLabel = UILabel().then { view in
        view.font = .pretendardRegular12
        view.text = L10n.MyPage.RetrospectCount.title
    }
    
    private lazy var retrospectVStack = UIStackView.make(
        with: [retrospectLabel, retrospectTitleLabel],
        axis: .vertical,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 9
    )
    
    private var email = UILabel().then { view in
        view.font = .pretendardRegular12
    }
    
    private var tableView = UITableView().then { view in
        view.isScrollEnabled = false
        view.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.id)
    }
}

// MARK: - Layout

extension MyPageViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            scrollView,
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            profile,
            nickname,
            email,
            seedVStack,
            pointVStack,
            retrospectVStack,
            tableView
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        contentView.snp.makeConstraints{ make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
        profile.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        nickname.snp.makeConstraints { make in
            make.top.equalTo(profile.snp.bottom).offset(11)
            make.centerX.equalTo(profile.snp.centerX)
        }
        
        email.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(4)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        pointVStack.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(38)
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        seedVStack.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerY.equalTo(pointVStack)
            make.leading.equalTo(contentView.snp.leading).offset(40)
        }
        
        retrospectVStack.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(45)
            make.centerY.equalTo(pointVStack)
            make.trailing.equalTo(contentView.snp.trailing).offset(-40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(seedVStack.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(tableView.contentSize.height)
        }
    }
}
