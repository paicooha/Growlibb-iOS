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
import FSCalendar

class HomeViewController: BaseViewController {
    
    lazy var homeDataManager = HomeDataManager()
    private var userKeyChainService: UserKeychainService
    var retroSpectList = [LatestRetrospectionInfo]()
    var dateUtil = DateUtil.shared
    
    var datesWithEvent = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
//        viewModelOutput()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        retrospectListTableView.delegate = self
        retrospectListTableView.dataSource = self
        
        retrospectListTableView.register(HomeRetrospectTableViewCell.self, forCellReuseIdentifier: HomeRetrospectTableViewCell.id)

        homeDataManager.getHome(viewController: self, date: DateUtil.shared.formattedString(for: Date(), format: .yyyyMDash))
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.userKeyChainService = BasicUserKeyChainService.shared
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: HomeViewModel

    private func viewModelInput() {
        prevMonthButton.rx.tap
            .subscribe({_ in
                self.scrollCurrentPage(isPrev: true)
            })
            .disposed(by: disposeBag)
        
        nextMonthButton.rx.tap
            .subscribe({ _ in
                self.scrollCurrentPage(isPrev: false)
            })
            .disposed(by: disposeBag)
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
    
    private var currentPage: Date?
    
    private func scrollCurrentPage(isPrev: Bool) { //클릭씨 이전 달 / 다음달 띄우기 위한 메소드
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
            
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? Date())
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
        
        homeDataManager.getHome(viewController: self, date: DateUtil.shared.formattedString(for: self.currentPage ?? Date(), format:.yyyyMDash))
        
        self.calendarHeaderTitle.text = DateUtil.shared.formattedString(for: self.currentPage!, format: DateFormat.yyyyMKR)
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
    
    private var retrospectTitle = UILabel().then { view in
        view.font = .pretendardMedium16
        view.textColor = .black
        view.text = L10n.Home.Recent.title
    }
    
    private var retrospectListTableView = UITableView().then { view in
        view.isHidden = true
        view.separatorColor = .clear //구분선 없애기
        view.showsVerticalScrollIndicator = false
    }
    
    private var noRetrospectView = UIButton().then { view in
        view.isHidden = true
        
        view.backgroundColor = .veryLightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        view.setTitle(L10n.Home.Recent.nodata, for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .pretendardMedium12
    }
    
    private var goRetrospectButton = LongButton().then { view in
        view.isHidden = true
        view.titleLabel?.font = .pretendardMedium12
        view.setTitle(L10n.Main.Button.goRetrospect, for: .normal)
    }
    
    private var calendar = FSCalendar().then { view in
        view.scope = .month //월 표시
        view.locale = Locale(identifier: "ko_KR") //요일을 한글로 표시하기 위함
        view.scrollEnabled = false //스크롤 가능 여부
        
        // 헤더 없애기
        view.headerHeight = 0

        // 캘린더
        view.appearance.todayColor = .primaryBlue
        view.appearance.weekdayTextColor = .black //일~토 제목 타이틀 색
        view.weekdayHeight = 34

        view.appearance.eventDefaultColor = .primaryBlue.withAlphaComponent(0.4) //이벤트 컬러

    }
    
    private var prevMonthButton = UIButton().then{ view in
        view.setBackgroundImage(Asset.icArrow2Left.image, for: .normal)
        view.snp.makeConstraints{ make in
            make.width.equalTo(7)
            make.height.equalTo(14)
        }
        view.contentMode = .scaleAspectFit
    }
    
    private var nextMonthButton = UIButton().then{ view in
        view.setBackgroundImage(Asset.icArrow2Right.image, for: .normal)
        view.snp.makeConstraints{ make in
            make.width.equalTo(7)
            make.height.equalTo(14)
        }
    }
    
    private var calendarHeaderTitle = UILabel().then { view in
        view.font = .pretendardMedium16
        view.textColor = .black
        view.text = DateUtil.shared.formattedString(for: Date(), format: DateFormat.yyyyMKR)
    }
}

// MARK: - Layout

extension HomeViewController {
    private func setupViews() {

        view.addSubviews([
            logo,
            dateLabel,
            titleLabel,
            retrospectTitle,
            retrospectListTableView,
            noRetrospectView,
            goRetrospectButton,
            calendar,
            prevMonthButton,
            nextMonthButton,
            calendarHeaderTitle
        ])
        
        let attributedTitleString = NSMutableAttributedString(string: "\(self.userKeyChainService.nickName)\(L10n.Home.Title.nickname)")
        attributedTitleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.primaryBlue, range: NSRange(location: 0, length: self.userKeyChainService.nickName.count+2))
        
        titleLabel.attributedText = attributedTitleString
    }

    private func initialLayout() {
        
        logo.snp.makeConstraints{ make in
            make.top.equalTo(view.snp.top).offset(70) //노치 44
            make.leading.equalTo(view.snp.leading).offset(25)
        }
        
        dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.leading.equalTo(logo.snp.leading)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(dateLabel.snp.leading)
        }
        
        calendarHeaderTitle.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(53)
            make.centerX.equalTo(calendar.snp.centerX)
        }
        
        prevMonthButton.snp.makeConstraints{ make in
            make.leading.equalTo(calendar.snp.leading).offset(25)
            make.centerY.equalTo(calendarHeaderTitle.snp.centerY)
        }
        
        nextMonthButton.snp.makeConstraints{ make in
            make.trailing.equalTo(calendar.snp.trailing).offset(-25)
            make.centerY.equalTo(calendarHeaderTitle.snp.centerY)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(calendarHeaderTitle.snp.bottom).offset(30)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(200)
        }
        
        retrospectTitle.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(52)
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
        
        retrospectListTableView.snp.makeConstraints{ make in
            make.top.equalTo(retrospectTitle.snp.bottom).offset(15)
            make.leading.equalTo(retrospectTitle.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        noRetrospectView.snp.makeConstraints{ make in
            make.top.equalTo(retrospectTitle.snp.bottom).offset(15)
            make.leading.equalTo(retrospectTitle.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.height.equalTo(124)
        }
        
        goRetrospectButton.snp.makeConstraints{ make in
            make.top.equalTo(noRetrospectView.snp.bottom).offset(15)
            make.leading.equalTo(retrospectTitle.snp.leading)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
        }
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance { //달력
    // 날짜 색 지정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if dateUtil.formattedString(for: dateUtil.now, format: .yyMMdd) != dateUtil.formattedString(for: date, format: .yyMMdd) { //'오늘'이 아닐 경우
            if date < dateUtil.now { //이전 날짜일 경우
                if Calendar.current.shortWeekdaySymbols[day] == "일" {
                    return .salmon.withAlphaComponent(0.4)
                } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
                    return .cornFlower.withAlphaComponent(0.4)
                } else {
                    return .black.withAlphaComponent(0.4)
                }
            }
            else if date > dateUtil.now{ //이후 날짜일 경우
                if Calendar.current.shortWeekdaySymbols[day] == "일" {
                    return .salmon
                } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
                    return .cornFlower
                } else {
                    return .black
                }
            }
            else{
                return .black
            }
        }
        else{
            return .white
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int { //이벤트가 있을 시, 점을 몇개 표시할건지
        if self.datesWithEvent.contains(date){
            return 1
        }
        else{
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool { //캘린더 날짜 선택 가능여부
        return false
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) { //이벤트 dot 반경 지정
        let eventScaleFactor: CGFloat = 1.5
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        retroSpectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeRetrospectTableViewCell.id) as? HomeRetrospectTableViewCell else { return .init() }
        cell.selectionStyle = .none // 셀 클릭 시 반짝임 효과 제거
        
        let apiDate = DateUtil.shared.getDate(from: retroSpectList[indexPath.row].writtenDate, format: .yyyyMddDash)
        cell.label.text = "\(DateUtil.shared.formattedString(for: apiDate!, format: .yyyyMddKR))🌱"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}

extension HomeViewController {
    func didSuccessGetHome(result: GetHomeResult){
        if result.latestRetrospectionInfos.isEmpty{
            noRetrospectView.isHidden = false
            goRetrospectButton.isHidden = false
        }
        else{
            if retroSpectList.isEmpty {
                retroSpectList.append(contentsOf: result.latestRetrospectionInfos)
                retrospectListTableView.reloadData()
            }
            
            noRetrospectView.isHidden = true
            goRetrospectButton.isHidden = true
                        
            retrospectListTableView.isHidden = false
        }
        
        if !result.retrospectionDates.isEmpty{
            for i in result.retrospectionDates{
                datesWithEvent.append(DateUtil.shared.getDate(from: i, format: .yyyyMddDash)!)
            }
            calendar.reloadData()
        }
    }
    
    func failedToRequest(message: String){
        noRetrospectView.isHidden = false
        goRetrospectButton.isHidden = false
        
        AppContext.shared.makeToast(message)
    }
}
