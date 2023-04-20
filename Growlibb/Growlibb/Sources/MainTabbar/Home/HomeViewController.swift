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

final class HomeViewController: BaseViewController { //final : 이후에 상속될 가능성이 없음을 의미함으로써 성능을 향상시킴
    
    lazy var homeDataManager = HomeDataManager()
    private var userKeyChainService: UserKeychainService
    var retroSpectList = [LatestRetrospectionInfo]()
    var dateUtil = DateUtil.shared
    private var observer: NSObjectProtocol?
    
    var datesWithRetrospect = [Date]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        retrospectListTableView.delegate = self
        retrospectListTableView.dataSource = self
        
        retrospectListTableView.register(HomeRetrospectTableViewCell.self, forCellReuseIdentifier: HomeRetrospectTableViewCell.id)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [unowned self] _ in
            changeTitleAndCalendarDate()
        }
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.userKeyChainService = BasicUserKeyChainService.shared
        super.init()
    }
    
    deinit { //옵저버 해지 -> 메모리 관리
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeTitleAndCalendarDate()
    }
    
    func changeTitleAndCalendarDate(){
        if dateLabel.text != DateUtil.shared.formattedString(for: DateUtil.shared.now, format: .yyMMdd) { //날짜가 달라진 경우 바꿔주기
            dateLabel.text = DateUtil.shared.formattedString(for: DateUtil.shared.now, format: .yyMMdd)
            calendar.appearance.todayColor = .primaryBlue //오늘날짜로 파란 dot 재설정
            calendar.reloadData()
        }
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
        
        goRetrospectButton.rx.tap
            .bind(to: viewModel.inputs.writeretrospect)
            .disposed(by: disposeBag)
        
        viewModel.routeInputs.needUpdate
            .subscribe(onNext: { _ in
                self.homeDataManager.getHome(viewController: self, date: DateUtil.shared.formattedString(for: Date(), format: .yyyyMDash))
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
    
    private var scrollView = UIScrollView(frame: .zero).then { view in
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private var retrospectTitle = UILabel().then { view in
        view.font = .pretendardMedium16
        view.textColor = .black
        view.text = L10n.Home.Recent.title
    }
    
    private var retrospectListTableView = UITableView().then { view in
        view.isHidden = true
        view.separatorColor = .clear //구분선 없애기
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
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
            scrollView
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
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
        
        calendarHeaderTitle.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(53)
            make.centerX.equalTo(calendar.snp.centerX)
        }
        
        prevMonthButton.snp.makeConstraints{ make in
            make.leading.equalTo(calendar.snp.leading).offset(20)
            make.centerY.equalTo(calendarHeaderTitle.snp.centerY)
        }
        
        nextMonthButton.snp.makeConstraints{ make in
            make.trailing.equalTo(calendar.snp.trailing).offset(-20)
            make.centerY.equalTo(calendarHeaderTitle.snp.centerY)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(calendarHeaderTitle.snp.bottom).offset(30)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.height.equalTo(230)
        }
        
        retrospectTitle.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(26)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
        }
        
        retrospectListTableView.snp.makeConstraints{ make in
            make.top.equalTo(retrospectTitle.snp.bottom).offset(15)
            make.leading.equalTo(retrospectTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(189)
        }
        
        noRetrospectView.snp.makeConstraints{ make in
            make.top.equalTo(retrospectTitle.snp.bottom).offset(15)
            make.leading.equalTo(retrospectTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(124)
        }
        
        goRetrospectButton.snp.makeConstraints{ make in
            make.top.equalTo(noRetrospectView.snp.bottom).offset(15)
            make.leading.equalTo(retrospectTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.bottom.equalToSuperview().offset(-21)
            make.height.equalTo(50)
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
        else{ //오늘 -> 하얀색
            return .white
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int { //이벤트가 있을 시, 날짜 아래 회고가 있을 때의 점을 몇개 표시할건지
        if self.datesWithRetrospect.contains(date){
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
            
            retrospectListTableView.isHidden = true
            
            retrospectListTableView.snp.removeConstraints()
            
            noRetrospectView.snp.makeConstraints{ make in
                make.top.equalTo(retrospectTitle.snp.bottom).offset(15)
                make.leading.equalTo(retrospectTitle.snp.leading)
                make.trailing.equalTo(contentView.snp.trailing).offset(-28)
                make.height.equalTo(124)
            }
            
            goRetrospectButton.snp.makeConstraints{ make in
                make.top.equalTo(noRetrospectView.snp.bottom).offset(15)
                make.leading.equalTo(retrospectTitle.snp.leading)
                make.trailing.equalTo(contentView.snp.trailing).offset(-28)
                make.bottom.equalToSuperview().offset(-21)
                make.height.equalTo(50)
            }
        }
        else{ //회고 데이터가 있을 경우
            noRetrospectView.isHidden = true
            goRetrospectButton.isHidden = true
                        
            retrospectListTableView.isHidden = false
            
            retroSpectList.removeAll()
            retroSpectList.append(contentsOf: result.latestRetrospectionInfos)
            retrospectListTableView.reloadData()
            retrospectListTableView.layoutIfNeeded()
            
            noRetrospectView.snp.removeConstraints()
            goRetrospectButton.snp.removeConstraints()
            
            retrospectListTableView.snp.makeConstraints{ make in
                make.top.equalTo(retrospectTitle.snp.bottom).offset(15)
                make.leading.equalTo(retrospectTitle.snp.leading)
                make.trailing.equalTo(contentView.snp.trailing).offset(-28)
                make.bottom.equalToSuperview().offset(-21)
                make.height.equalTo(66 * retroSpectList.count)
            }
        }
        
        if !result.retrospectionDates.isEmpty{
            datesWithRetrospect.removeAll()
            
            for i in result.retrospectionDates{
                datesWithRetrospect.append(DateUtil.shared.getDate(from: i, format: .yyyyMddDash)!)
//                print(DateUtil.shared.getDate(from: i, format: .yyyyMddDash)!)
//                print(DateUtil.shared.now)
            }
            datesWithRetrospect = datesWithRetrospect.filter { dateUtil.formattedString(for: $0, format: .yyMMdd) != dateUtil.formattedString(for: dateUtil.now, format: .yyMMdd) }
            calendar.reloadData()
        }
    }
    
    func failedToRequest(message: String){
        noRetrospectView.isHidden = false
        goRetrospectButton.isHidden = false
        
        AppContext.shared.makeToast(message)
    }
}
