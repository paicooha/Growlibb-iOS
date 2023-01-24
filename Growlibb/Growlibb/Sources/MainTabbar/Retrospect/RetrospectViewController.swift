//
//  RetrospectViewController.swift
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

class RetrospectViewController: BaseViewController {
    
    var level = 0
    private var userKeyChainService: UserKeychainService
    var dateUtil = DateUtil.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: RetrospectViewModel) {
        self.viewModel = viewModel
        self.userKeyChainService = BasicUserKeyChainService.shared
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: RetrospectViewModel

    private func viewModelInput() {
        goRetrospectButton.rx.tap
            .bind(to: viewModel.inputs.writeretrospect)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput(){
        viewModel.outputs.retrospectInfo
            .subscribe(onNext: { [weak self] info in
                self!.stackView.isHidden = false
                
                var gender = ""
                if info.gender == "M"{
                    gender = L10n.Retrospect.Gender.Icon.man
                }
                else{
                    gender = L10n.Retrospect.Gender.Icon.woman
                }
                
                if info.point <= 50 {
                    self!.level = 2
                }
                else if info.point <= 200 {
                    self!.level = 3
                }
                else if info.point <= 700 {
                    self!.level = 4
                }
                else if info.point <= 2000 {
                    self!.level = 5
                }
                else if info.point <= 5000 {
                    self!.level = 6
                }
                
                self!.pointLeftView.label.text = "\(gender)\(self!.userKeyChainService.nickName)\(L10n.Retrospect.Point.Description.first)\(info.point)\(L10n.Retrospect.Point.Description.second)"
                self!.pointRightView.label.text = "\(info.needPointForLevel)\(L10n.Retrospect.Morepoint.Description.first)\(self!.level)\(L10n.Retrospect.Morepoint.Description.second)"
                self!.countLeftView.label.text = "\(gender)\(self!.userKeyChainService.nickName)\(L10n.Retrospect.Continuous.Description.first)\(info.continuousWritingCount)\(L10n.Retrospect.Continuous.Description.second)"
                self!.countRightView.label.text = "\(info.needContinuousRetrospection)\(L10n.Retrospect.Morecontinuous.description)"
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var scrollView = UIScrollView(frame: .zero).then { make in
        make.showsHorizontalScrollIndicator = false
        make.showsVerticalScrollIndicator = false
        make.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var logo = UIImageView().then { view in
        view.snp.makeConstraints{ make in
            make.width.height.equalTo(42)
        }
        view.image = Asset.icGrowlibbLogo.image
    }
    
    private var dateLabel = UILabel().then { view in
        view.font = .pretendardMedium20
        view.textColor = .primaryBlue
        view.text = DateUtil.shared.formattedString(for: DateUtil.shared.now, format: .yyMMdd)
    }
    
    private var titleLabel = UILabel().then { view in
        view.font = .pretendardMedium20

    }
    
    //애니메이션 이미지 추가해야됨

    private var pointLeftView = RetrospectLeftView().then { view in
        view.snp.makeConstraints{ make in
            make.width.equalTo(210)
            make.height.equalTo(70)
        }
    }
    
    private var pointRightView = RetrospectRightView().then { view in
        view.snp.makeConstraints{ make in
            make.width.equalTo(210)
            make.height.equalTo(70)
        }
    }
    
    private var countLeftView = RetrospectLeftView().then { view in
        view.snp.makeConstraints{ make in
            make.width.equalTo(210)
            make.height.equalTo(70)
        }
    }
    
    private var countRightView = RetrospectRightView().then { view in
        view.snp.makeConstraints{ make in
            make.width.equalTo(210)
            make.height.equalTo(70)
        }
    }
    
    private lazy var stackView = UIStackView.make(
        with: [pointLeftView,
              pointRightView,
              countLeftView,
              countRightView],
        axis: .vertical,
        alignment: .fill,
        distribution: .equalSpacing,
        spacing: 12
    ).then { view in
        view.isHidden = true // 네트워크 연결 성공 시 다시 보이도록 수정
    }
    
    private var goRetrospectButton = LongButton().then { view in
        view.titleLabel?.font = .pretendardMedium12
        view.setTitle(L10n.Main.Button.goRetrospect, for: .normal)
    }
}

// MARK: - Layout

extension RetrospectViewController {
    private func setupViews() {
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        
        view.addSubviews([
            scrollView
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            logo,
            dateLabel,
            titleLabel,
            stackView,
            goRetrospectButton
        ])
        
        let attributedTitleString = NSMutableAttributedString(string: "\(self.userKeyChainService.nickName)\(L10n.Home.Title.nickname)")
        attributedTitleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primaryBlue, range: NSRange(location: 0, length: self.userKeyChainService.nickName.count+2))
        
        titleLabel.attributedText = attributedTitleString
    }

    private func initialLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
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
        
        logo.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(UIScreen.main.isWiderThan375pt ? 70 : 26) //노치 44
            make.leading.equalTo(contentView.snp.leading).offset(25)
        }
        
        dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.leading.equalTo(logo.snp.leading)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(dateLabel.snp.leading)
        }
        
        stackView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
        }
        
        goRetrospectButton.snp.makeConstraints{ make in
            make.top.equalTo(stackView.snp.bottom).offset(65)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.bottom.equalTo(contentView.snp.bottom).offset(-21)
        }
    }
}
