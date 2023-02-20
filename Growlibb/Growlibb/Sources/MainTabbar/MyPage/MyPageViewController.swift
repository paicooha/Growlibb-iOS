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
import Kingfisher

class MyPageViewController: BaseViewController {

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
//        navBar.rightBtnItem.rx.tap
//            .bind(to: viewModel.inputs.goCS)
//            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                switch index.row {
                case 0:
                    self?.viewModel.inputs.goRetrospectList.onNext(())
                case 1:
                    self?.viewModel.inputs.editProfile.onNext(())
                case 2:
                    self?.viewModel.inputs.editPassword.onNext(())
                case 3:
                    self?.viewModel.inputs.editPhoneNumber.onNext(())
                case 4:
                    self?.viewModel.inputs.editNoti.onNext(())
                case 5:
                    self?.viewModel.inputs.goCS.onNext(())
                case 6:
                    self?.viewModel.inputs.logout.onNext(())
                default:
                    self?.viewModel.inputs.goResign.onNext(())

                }
            })
            .disposed(by: disposeBag)
    }

    private func viewModelOutput(){

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.mypage
            .subscribe(onNext: { mypage in
                self.nickname.text = mypage.nickname
                self.email.text = mypage.email
                self.seedlevelLabel.text = "\(mypage.seedLevel)"
                self.pointLabel.text = "\(mypage.point)"
                self.retrospectLabel.text = "\(mypage.retrospectionCount)"
                
                let processor = ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 100)) |> RoundCornerImageProcessor(cornerRadius: 50)
                self.profile.kf.setImage(with: URL(string: mypage.profileImageUrl ?? ""), placeholder: Asset.icMyProfile.image, options: [.processor(processor)])
            })
            .disposed(by: disposeBag)
        
        typealias MyPageListDataSource
        = RxTableViewSectionedReloadDataSource<MyPageSection>
        
        let myListTableViewDataSource = MyPageListDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.id, for: indexPath) as? MyPageCell
            else { return UITableViewCell() }
                        
            cell.label.text = item
            
            cell.preservesSuperviewLayoutMargins = false //separator 꽉 안차는 현상 해결하기 위한 코드
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
        
        viewModel.outputs.mypagelist
            .map { [MyPageSection(items: $0)]}
            .bind(to: tableView.rx.items(dataSource: myListTableViewDataSource))
            .disposed(by: disposeBag)
    }

//    private var navBar = NavBar().then { navBar in
////        navBar.rightBtnItem.isHidden = false
//        navBar.titleLabel.isHidden = true
//    }
    
    private var scrollView = UIScrollView().then { view in
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var profile = UIImageView().then { view in
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
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
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
            make.top.equalTo(contentView.snp.top).offset(58)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.height.equalTo(100)
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
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(497)
        }
    }
}
