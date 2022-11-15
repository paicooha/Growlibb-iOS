//
//  HomeViewController.swift
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
import Toast_Swift
import UIKit

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: HomeViewModel

    private func viewModelInput() {
//        bindBottomSheetGesture()
//
//        showClosedPostView.rx.tapGesture(configuration: nil)
//            .map { _ in }
//            .bind(to: viewModel.inputs.tapShowClosedPost)
//            .disposed(by: disposeBag)
//
//        postCollectionView.rx.itemSelected
//            .map { $0.item }
//            .bind(to: viewModel.inputs.tapPost)
//            .disposed(by: disposeBag)
//
//        selectedPostCollectionView.rx.itemSelected
//            .map { _ in }
//            .bind(to: viewModel.inputs.tapSelectedPost)
//            .disposed(by: disposeBag)
//
//        mapView.postSelected
//            .bind(to: viewModel.inputs.tapPostPin)
//            .disposed(by: disposeBag)
//
//        mapView.regionWillChange
//            .bind(to: viewModel.inputs.moveRegion)
//            .disposed(by: disposeBag)
//
//        mapView.regionChanged
//            .bind(to: viewModel.inputs.regionChanged)
//            .disposed(by: disposeBag)
//
//        homeLocationButton.rx.tapGesture(configuration: nil)
//            .map { _ in }
//            .bind(to: viewModel.inputs.toHomeLocation)
//            .disposed(by: disposeBag)
//
//        refreshPostListButton.rx.tapGesture(configuration: nil)
//            .map { _ in true }
//            .bind(to: viewModel.inputs.needUpdate)
//            .disposed(by: disposeBag)
//
//        writePostButton.rx.tapGesture(configuration: nil)
//            .map { _ in }
//            .bind(to: viewModel.inputs.writingPost)
//            .disposed(by: disposeBag)
//
//        filterIconView.rx.tapGesture(configuration: nil)
//            .map { _ in }
//            .bind(to: viewModel.inputs.showDetailFilter)
//            .disposed(by: disposeBag)
//
//        orderTagView.rx.tapGesture(configuration: nil)
//            .map { _ in }
//            .bind(to: viewModel.inputs.tapPostListOrder)
//            .disposed(by: disposeBag)
//
//        runningTagView.rx.tapGesture(configuration: nil)
//            .map { _ in }
//            .bind(to: viewModel.inputs.tapRunningTag)
//            .disposed(by: disposeBag)
//
//        navBar.rightBtnItem.rx.tap
//            .bind(to: viewModel.inputs.tapAlarm)
//            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
//        postCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
//        selectedPostCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
//        typealias PostSectionDataSource = RxCollectionViewSectionedAnimatedDataSource<BasicPostSection>
//
//        viewModel.outputs.posts
//            .map {
//                $0.reduce(into: [PostCellConfig]()) {
//                    $0.append(PostCellConfig(from: $1))
//                }
//            }
//            .map { [BasicPostSection(items: $0)] }
//            .bind(to: postCollectionView.rx.items(dataSource: PostSectionDataSource { [weak self] _, collectionView, indexPath, item in
//                guard let self = self else { return UICollectionViewCell() }
//                return self.configureCell(collectionView, indexPath, item)
//            }))
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.showClosedPost
//            .subscribe(onNext: { [weak self] show in
//                self?.showClosedPost(show)
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.posts
//            .subscribe(onNext: { [unowned self] posts in
//                self.mapView.update(with: posts)
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.posts
//            .map { $0.count }
//            .subscribe(onNext: { [unowned self] count in
//                let hideEmptyGuide = count != 0
//                self.postEmptyGuideLabel.isHidden = hideEmptyGuide
//                self.adviseWritingPostView.isHidden = hideEmptyGuide
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.changeRegion
//            .subscribe(onNext: { [weak self] region in
//                self?.mapView.setRegion(to: region.location, radius: region.distance)
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.showRefreshRegion
//            .map { !$0 }
//            .subscribe(onNext: { [weak self] hidden in
//                self?.refreshPostListButton.isHidden = hidden
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.focusSelectedPost
//            .map {
//                if let post = $0 {
//                    return [PostCellConfig(from: post)]
//                } else {
//                    return []
//                }
//            }
//            .map { [BasicPostSection(items: $0)] }
//            .bind(to: selectedPostCollectionView.rx.items(dataSource: PostSectionDataSource { [weak self] _, collectionView, indexPath, item in
//                guard let self = self else { return UICollectionViewCell() }
//                return self.configureCell(collectionView, indexPath, item)
//            }))
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.focusSelectedPost
//            .subscribe(onNext: { [unowned self] post in
//                let hideSelectedPost = (post == nil)
//                self.postCollectionView.isHidden = !hideSelectedPost
//                self.selectedPostCollectionView.isHidden = hideSelectedPost
//
//                if post != nil {
//                    self.mapView.isAnnotationHidden = true
//                    self.setBottomSheetState(to: .halfOpen, animated: true) { [weak self] in
//                        self?.mapView.isAnnotationHidden = false
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.highLightFilter
//            .subscribe(onNext: { [unowned self] highlight in
//                self.filterIconView.image = highlight ? Asset.filterHighlighted.uiImage : Asset.filter.uiImage
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.postListOrderChanged
//            .subscribe(onNext: { [unowned self] listOrder in
//                self.orderTagView.label.text = listOrder.text
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.runningTagChanged
//            .subscribe(onNext: { [unowned self] tag in
//                self.runningTagView.label.text = tag.name
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.titleLocationChanged
//            .subscribe(onNext: { [unowned self] title in
//                if let title = title {
//                    navBar.titleLabel.font = .iosBody17R
//                    navBar.titleLabel.text = title
//                    navBar.titleLabel.textColor = .darkG35
//                    navBar.titleSpacing = 12
//                } else {
//                    navBar.titleLabel.font = .aggroLight
//                    navBar.titleLabel.text = L10n.Home.PostList.NavBar.title
//                    navBar.titleLabel.textColor = .primarydark
//                    navBar.titleSpacing = 8
//                }
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.alarmChecked
//            .subscribe(onNext: { [weak self] isChecked in
//                self?.navBar.rightBtnItem.setImage(isChecked ? Asset.alarmNomal.uiImage : Asset.alarmNew.uiImage, for: .normal)
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.toast
//            .subscribe(onNext: { message in
//                AppContext.shared.makeToast(message)
//            })
//            .disposed(by: disposeBag)
    }
//
//    private func bindBottomSheetGesture() {
//        bottomSheet.rx.panGesture()
//            .when(.changed)
//            .filter { [unowned self] gesture in
//                let location = gesture.location(in: self.bottomSheet)
//                return isBottomSheetPanGestureEnable(with: location)
//            }
//            .asTranslation()
//            .subscribe(onNext: { [unowned self] translation, _ in
//                self.onPanGesture(translation: translation)
//            })
//            .disposed(by: disposeBag)
//
//        bottomSheet.rx.panGesture()
//            .when(.ended)
//            .asTranslation()
//            .subscribe(onNext: { [unowned self] _, _ in
//                onPanGestureEnded()
//            })
//            .disposed(by: disposeBag)
//    }
//
//    private func showClosedPost(_ show: Bool) {
//        if show {
//            showClosedPostView.label.font = Constants.BottomSheet.SelectionLabel.HighLighted.font
//            showClosedPostView.label.textColor = Constants.BottomSheet.SelectionLabel.HighLighted.textColor
//            showClosedPostView.backgroundColor = Constants.BottomSheet.SelectionLabel.HighLighted.backgroundColor
//            showClosedPostView.layer.borderWidth = Constants.BottomSheet.SelectionLabel.HighLighted.borderWidth
//            showClosedPostView.layer.borderColor = Constants.BottomSheet.SelectionLabel.HighLighted.borderColor
//        } else {
//            showClosedPostView.label.font = Constants.BottomSheet.SelectionLabel.Normal.font
//            showClosedPostView.label.textColor = Constants.BottomSheet.SelectionLabel.Normal.textColor
//            showClosedPostView.backgroundColor = Constants.BottomSheet.SelectionLabel.Normal.backgroundColor
//            showClosedPostView.layer.borderWidth = Constants.BottomSheet.SelectionLabel.Normal.borderWidth
//            showClosedPostView.layer.borderColor = Constants.BottomSheet.SelectionLabel.Normal.borderColor
//        }
//    }
//
//    private func configureCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: BasicPostSection.Item) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicPostCell.id, for: indexPath) as? BasicPostCell
//        else { return UICollectionViewCell() }
//
//        viewModel.outputs.bookMarked
//            .filter { $0.id == item.id }
//            .map { $0.marked }
//            .subscribe(onNext: { [weak cell] marked in
//                cell?.postInfoView.bookMarkIcon.isSelected = marked
//            })
//            .disposed(by: cell.disposeBag)
//
//        cell.postInfoView.bookMarkIcon.rx.tap
//            .map { item.id }
//            .subscribe(onNext: { [weak self] id in
//                self?.viewModel.inputs.tapPostBookmark.onNext(id)
//            })
//            .disposed(by: cell.disposeBag)
//
//        cell.configure(with: item)
//        return cell
//    }
//
//    enum Constants {
//        enum NavigationBar {
//            static let backgroundColor: UIColor = .darkG7
//        }
//
//        enum RefreshButton {
//            static let topSpacing: CGFloat = 16
//
//            static let iconSize: CGFloat = 20
//            static let text: String = L10n.Home.Map.RefreshButton.title
//            static let paddingLeft: CGFloat = 10
//            static let paddingRight: CGFloat = 14
//            static let spacing: CGFloat = 4
//            static let height: CGFloat = 36
//        }
//
//        enum HomeLocationButton {
//            static let width: CGFloat = 40
//            static let height: CGFloat = 40
//            static let leading: CGFloat = 12
//            static let bottom: CGFloat = 12
//            static let bottomLimit: CGFloat = Constants.BottomSheet.heightMiddle + Constants.HomeLocationButton.bottom
//        }
//
//        enum BottomSheet {
//            static let backgrouncColor: UIColor = .darkG7
//            static let cornerRadius: CGFloat = 12
//            static let heightMiddle: CGFloat = 294
//            static let heightMin: CGFloat = 65
//
//            enum GreyHandle {
//                static let top: CGFloat = 16
//                static let width: CGFloat = 37
//                static let height: CGFloat = 3
//                static let color: UIColor = .darkG6
//            }
//
//            enum Title {
//                static let leading: CGFloat = 16
//                static let top: CGFloat = 24
//                static let height: CGFloat = 29
//                static let color: UIColor = .darkG25
//                static let font: UIFont = .iosTitle21Sb
//                static let text: String = L10n.Home.BottomSheet.title
//            }
//
//            enum SelectionLabel {
//                static let iconSize: CGSize = .init(width: 16, height: 16)
//                static let height: CGFloat = 27
//                static let cornerRadius: CGFloat = height / 2.0
//                static let padding: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 6)
//
//                enum HighLighted {
//                    static let font: UIFont = .iosBody13B
//                    static let backgroundColor: UIColor = .primarydark
//                    static let textColor: UIColor = .darkBlack
//                    static let borderWidth: CGFloat = 0
//                    static let borderColor: CGColor = UIColor.primarydark.cgColor
//                    static let icon: UIImage = Asset.chevronDown.uiImage.withTintColor(.darkBlack)
//                }
//
//                enum Normal {
//                    static let font: UIFont = .iosBody13R
//                    static let backgroundColor: UIColor = .clear
//                    static let textColor: UIColor = .darkG3
//                    static let borderWidth: CGFloat = 1
//                    static let borderColor: CGColor = UIColor.darkG3.cgColor
//                    static let icon: UIImage = Asset.chevronDown.uiImage.withTintColor(.darkG3)
//                }
//
//                enum RunningTag {
//                    static let leading: CGFloat = 16
//                    static let top: CGFloat = Title.top + Title.height + 23
//                }
//
//                enum OrderTag {
//                    static let leading: CGFloat = 12
//                }
//
//                enum ShowClosedPost {
//                    static let leading: CGFloat = 12
//                    static let padding: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
//                }
//            }
//
//            enum PostList {
//                static let top: CGFloat = Title.top + Title.height + 70
//                static let minimumLineSpacing: CGFloat = 12
//            }
//        }
//    }

//    private var navBar = RunnerbeNavBar().then { navBar in
//        navBar.titleLabel.font = .aggroLight
//        navBar.titleLabel.text = L10n.Home.PostList.NavBar.title
//        navBar.titleLabel.textColor = .primarydark
//        navBar.rightBtnItem.setImage(Asset.alarmNew.uiImage, for: .normal)
//        navBar.rightSecondBtnItem.isHidden = true
//        navBar.titleSpacing = 8
//        navBar.backgroundColor = Constants.NavigationBar.backgroundColor
//    }
}

// MARK: - Layout

extension HomeViewController {
    private func setupViews() {

        view.addSubviews([
//            navBar,
        ])
    }

    private func initialLayout() {
//        navBar.snp.makeConstraints { make in
//            make.top.equalTo(view.snp.top)
//            make.leading.equalTo(view.snp.leading)
//            make.trailing.equalTo(view.snp.trailing)
//        }
    }
}
