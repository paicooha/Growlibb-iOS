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
import AdvancedPageControl

class WriteRetrospectTutorialModalViewController: BaseViewController {
    let tutorialImages = [Asset.icRetrospectTutorialKeep.image, Asset.icRetrospectTutorialKeep.image, Asset.icRetrospectTutorialProblem.image, Asset.icRetrospectTutorialTry.image]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        
        imageSlideCollectionView.delegate = self
        imageSlideCollectionView.dataSource = self
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
                UserDefaults.standard.set(true, forKey: "isPassedWriteRetrospectTutorial")
                self?.viewModel.inputs.close.onNext(())
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
    
    private var startButton = ShortButton().then { button in
        button.isHidden = true
        button.setTitle(L10n.Start.title, for: .normal)
        button.setBlueButton()
    }
    
    private lazy var imageSlideCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.scrollDirection = .horizontal

        layout.itemSize = CGSize(width: sheet.bounds.width - 26, height: 186)
        layout.minimumLineSpacing = 13
        layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        layout.scrollDirection = .horizontal
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WriteRetrospectTutorialCell.self, forCellWithReuseIdentifier: WriteRetrospectTutorialCell.id)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        
        return collectionView
    }()
    
    private var descriptionLabel = UILabel().then { view in
        view.font = .pretendardRegular12
        view.numberOfLines = 0
        view.text = L10n.WriteRetrospect.Modal.Tutorial.First.description
    }
    
    private var pageControl = AdvancedPageControlView()
}

// MARK: - Layout

extension WriteRetrospectTutorialModalViewController {
    private func setupViews() {
        view.backgroundColor = .modalBgColor
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: 4,
                                               height: 9.0, space: 12.0,
                                               raduis: 8.0,
                                                indicatorColor: UIColor.primaryBlue,
                                                dotsColor: .veryLightGray,
                                                isBordered: false,
                                                borderWidth: 0.0,
                                                indicatorBorderColor: .clear,
                                                indicatorBorderWidth: 0.0)

        view.addSubviews([
            sheet,
        ])

        sheet.addSubviews([
            titleLabel,
            skip,
            hDivider,
            imageSlideCollectionView,
            descriptionLabel,
            pageControl,
            startButton
        ])
    }

    private func initialLayout() {
        sheet.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(438)
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
        
        imageSlideCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(hDivider.snp.bottom).offset(20)
            make.leading.equalTo(sheet.snp.leading)
            make.trailing.equalTo(sheet.snp.trailing)
            make.height.equalTo(186)
        }
        
        descriptionLabel.snp.makeConstraints{ make in
            make.top.equalTo(imageSlideCollectionView.snp.bottom).offset(20)
            make.centerX.equalTo(sheet.snp.centerX)
        }
        
        pageControl.snp.makeConstraints{ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(sheet)
        }
        
        startButton.snp.makeConstraints{ make in
            make.top.equalTo(pageControl.snp.bottom).offset(13)
            make.width.equalTo(200)
            make.height.equalTo(39)
            make.centerX.equalTo(sheet.snp.centerX)
        }
    }
}

// collectionView
extension WriteRetrospectTutorialModalViewController: UICollectionViewDataSource,
                                                      UICollectionViewDelegate,
                                                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sheet.bounds.width - 26, height: 186)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageSlideCollectionView.dequeueReusableCell(withReuseIdentifier: WriteRetrospectTutorialCell.id, for: indexPath) as! WriteRetrospectTutorialCell
        
        cell.imageView.image = tutorialImages[indexPath.row]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width

        let page = Int(round(offSet / width))
        pageControl.setPage(page)
        
        switch page {
        case 0:
            descriptionLabel.text = L10n.WriteRetrospect.Modal.Tutorial.First.description
            startButton.isHidden = true
            break
        case 1:
            descriptionLabel.text = L10n.WriteRetrospect.Modal.Tutorial.Second.description
            startButton.isHidden = true
            break
        case 2:
            descriptionLabel.text = L10n.WriteRetrospect.Modal.Tutorial.Third.description
            startButton.isHidden = true
            break
        default:
            descriptionLabel.text = L10n.WriteRetrospect.Modal.Tutorial.Fourth.description
            startButton.isHidden = false
            break
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.imageSlideCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // CollectionView Item Size
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // 이동한 x좌표 값과 item의 크기를 비교 후 페이징 값 설정
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        
        // 스크롤 방향 체크
        // item 절반 사이즈 만큼 스크롤로 판단하여 올림, 내림 처리
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        // 위 코드를 통해 페이징 될 좌표 값을 targetContentOffset에 대입
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
}
