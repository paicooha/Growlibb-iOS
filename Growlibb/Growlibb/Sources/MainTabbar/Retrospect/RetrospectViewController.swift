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
import Gifu

class RetrospectViewController: BaseViewController {
    
    var level = 0
    private var userKeyChainService: UserKeychainService
    var dateUtil = DateUtil.shared
    var myeongeonList = [L10n.Retrospect.Myeongeon.first, L10n.Retrospect.Myeongeon.second, L10n.Retrospect.Myeongeon.third, L10n.Retrospect.Myeongeon.fourth, L10n.Retrospect.Myeongeon.fifth]
    var myeongeonindex = Int.random(in: 0...4)
                         
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
                
                self!.pointLeftView.label.text = "\(gender)\(self!.userKeyChainService.nickName)\(L10n.Retrospect.Point.Description.first)\(info.point)\(L10n.Retrospect.Point.Description.second)"
                self!.pointRightView.label.text = "\(info.needPointForLevel)\(L10n.Retrospect.Morepoint.Description.first)\(self!.userKeyChainService.level+1)\(L10n.Retrospect.Morepoint.Description.second)"
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
    
    private var titleLabel = UILabel().then { view in
        view.font = .pretendardSemibold20
        view.numberOfLines = 0
    }
    
//    private var animation = GIFImageView(frame: CGRect(x: 0, y: 0, width: 220, height: 220))

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
        titleLabel.text = myeongeonList[myeongeonindex] //명언 랜덤하게 보여주기
        
        view.addSubviews([
            scrollView
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            titleLabel,
//            animation,
            stackView,
            goRetrospectButton
        ])
        
//        switch userKeyChainService.level {
//        case 1:
//            animation.animate(withGIFNamed: "level_1")
//            break
//        case 2:
//            animation.animate(withGIFNamed: "level_2")
//            break
//        case 3:
//            animation.animate(withGIFNamed: "level_3")
//            break
//        default:
//            animation.animate(withGIFNamed: "level_4")
//            break
//        }
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
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(26)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-51)
        }
        
//        animation.snp.makeConstraints{ make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//            make.centerX.equalTo(contentView.snp.centerX)
//            make.width.height.equalTo(220)
//        }
        
        stackView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
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
