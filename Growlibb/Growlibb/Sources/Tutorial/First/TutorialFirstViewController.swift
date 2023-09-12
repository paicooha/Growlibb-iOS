//
//  TutorialViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/08.
//

import RxCocoa
import RxGesture
import RxSwift
import Then
import UIKit
import SnapKit

final class TutorialFirstViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
    }

    init(viewModel: TutorialFirstViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: TutorialFirstViewModel

    private func viewModelInput() {
        button.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBag)
    }

    private var navBar = NavBar()
    
    private var logo = LogoImageView()
    
    private var titleLabel = UILabel().then{ make in
        make.font = .pretendardSemibold20
        make.textColor = .black
        make.text = L10n.Tutorial.First.title
    }
    
    private var detailLabelBackground = UIView().then{ make in
        make.backgroundColor = .veryLightBlue
        make.clipsToBounds = true
        make.layer.cornerRadius = 30
        make.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner) //위쪽만 둥글게

    }
    
    private var detailLabel = UILabel().then{ make in
        make.font = .pretendardMedium16
        make.numberOfLines = 0
    }
    
    private var button = LongButton().then { make in
        make.setTitle(L10n.Next.Button.title, for: .normal)
        make.titleLabel?.textColor = .veryLightBlue
    }
}

// MARK: - Layout

extension TutorialFirstViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            logo,
            titleLabel,
            detailLabelBackground,
            detailLabel,
            button
        ])
        
        titleLabel.attributedText = NSMutableAttributedString(string: L10n.Tutorial.First.title)
            .addBlueStringStyleToRange(ranges: [NSRange(location: 4, length: 2)])
        
        let detailLabelParagraph = NSMutableParagraphStyle()
        detailLabelParagraph.lineSpacing = 6
        detailLabel.attributedText = NSMutableAttributedString(string: L10n.Tutorial.First.description)
            .addBlueStringStyleToRange(ranges: [NSRange(location: 42, length: 14)])
            .style(attrs: [.paragraphStyle: detailLabelParagraph], range: NSRange(location: 0, length: L10n.Tutorial.First.description.count))
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        logo.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(14)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(logo.snp.bottom).offset(16)
            make.leading.equalTo(logo.snp.leading)
        }
        
        detailLabelBackground.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(56)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabelBackground.snp.top).offset(UIScreen.main.isWiderThan375pt ? 74: 34)
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-34)
        }
        
        button.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(UIScreen.main.isWiderThan375pt ? -52 : -22)
        }
    }
}
