//
//  WriteRetrospectTutorialModalViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/16.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class WriteRetrospectTutorialModalViewController: BaseViewController {
    let tutorialImages = [Asset.icRetrospectTutorialDone.image, Asset.icRetrospectTutorialKeep.image, Asset.icRetrospectTutorialProblem.image, Asset.icRetrospectTutorialTry.image, Asset.icRetrospectTutorialPlus.image]
    let tutorialDescription = [L10n.WriteRetrospect.Modal.Tutorial.First.description,             L10n.WriteRetrospect.Modal.Tutorial.Second.description, L10n.WriteRetrospect.Modal.Tutorial.Third.description,
        L10n.WriteRetrospect.Modal.Tutorial.Fourth.description,
        L10n.WriteRetrospect.Modal.Tutorial.Final.description]
    
    var pageNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: WriteRetrospectTutorialViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: WriteRetrospectTutorialViewModel

    private func viewModelInput() {
        sheet.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)

        view.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        })
        .when(.recognized)
        .subscribe()
        .disposed(by: disposeBag)
        
        skip.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .subscribe({ [ weak self ] _ in
                UserDefaults.standard.set(true, forKey: "isPassedWriteRetrospectTutorial")
                self?.viewModel.inputs.close.onNext(())
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .subscribe({ [weak self] _ in
                if self?.pageNum == 4 {
                    self?.viewModel.inputs.close.onNext(())
                    UserDefaults.standard.set(true, forKey: "isPassedWriteRetrospectTutorial")
                }
                else if self?.pageNum == 3 {
                    self?.startButton.setTitle(L10n.Start.title, for: .normal)
                    self?.descriptionLabel.textAlignment = .center
                }
                self?.pageNum += 1
                self?.imageView.image = self?.tutorialImages[self!.pageNum%5]
                self?.descriptionLabel.text = self?.tutorialDescription[self!.pageNum%5]
                self?.indicator.text = "\(self!.pageNum+1)/5"
            })
            .disposed(by: disposeBag)
        
    }

    private func viewModelOutput() {
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private var sheet = UIView().then { view in
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
    }
    
    private var titleLabel = UILabel().then { label in
        label.text = L10n.WriteRetrospect.Modal.Tutorial.title
        label.font = .pretendardMedium12
    }
    
    private var skip = UILabel().then { label in
        label.text = L10n.WriteRetrospect.Modal.Tutorial.Skip.Button.title
        label.font = .pretendardRegular9
        label.textColor = .primaryBlue
    }
    
    private var hDivider = UIView().then { view in
        view.backgroundColor = .veryLightGray
    }
    
    private lazy var indicator = UILabel().then { view in
        view.font = .pretendardRegular12
        view.text = "\(self.pageNum+1)/5"
    }
    
    private lazy var imageView = UIImageView().then { view in
        view.image = self.tutorialImages[self.pageNum]
    }
    
    private var startButton = ShortButton().then { button in
        button.setTitle(L10n.Next.Button.title, for: .normal)
        button.setBlueButton()
    }
    
    private lazy var descriptionLabel = UILabel().then { view in
        view.font = .pretendardRegular12
        view.numberOfLines = 0
        view.text = self.tutorialDescription[self.pageNum]
    }
}

// MARK: - Layout

extension WriteRetrospectTutorialModalViewController {
    private func setupViews() {
        view.backgroundColor = .modalBgColor

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            titleLabel,
            skip,
            hDivider,
            indicator,
            imageView,
            descriptionLabel,
            startButton
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(408)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sheet.snp.top).offset(20)
            make.centerX.equalTo(sheet.snp.centerX)
        }
        
        skip.snp.makeConstraints{ make in
            make.leading.equalTo(sheet.snp.leading).offset(13)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(1)
        }
        
        indicator.snp.makeConstraints{ make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(sheet.snp.trailing).offset(-13)
        }
        
        imageView.snp.makeConstraints{ make in
            make.top.equalTo(hDivider.snp.bottom).offset(20)
            make.leading.equalTo(sheet.snp.leading).offset(13)
            make.trailing.equalTo(sheet.snp.trailing).offset(-13)
        }
        
        descriptionLabel.snp.makeConstraints{ make in
            make.top.equalTo(imageView.snp.bottom).offset(13)
            make.leading.equalTo(sheet.snp.leading).offset(32)
            make.trailing.equalTo(sheet.snp.trailing).offset(-32)
        }
        
        startButton.snp.makeConstraints{ make in
            make.bottom.equalTo(sheet.snp.bottom).offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(39)
            make.centerX.equalTo(sheet.snp.centerX)
        }
    }
}
