//
//  WriteRetrospectViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/15.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class WriteRetrospectViewController: BaseViewController {
    
    var doneTextList:[String] = []
    var keepTextList:[String] = []
    var problemTextList:[String] = []
    var tryTextList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()
        
        viewModelInput()
        viewModelOutput()
        
        if !UserDefaults.standard.bool(forKey: "isPassedWriteRetrospectTutorial") {
            viewModel.inputs.showTutorial.onNext(())
        }
        
        viewModel.routeInputs.needUpdate.onNext(true)
    }
    
    init(viewModel: WriteRetrospectViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: WriteRetrospectViewModel
    
    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .subscribe(onNext: { [self] _ in
                viewModel.inputs.backward.onNext(isAllListEmpty())
            })
            .disposed(by: disposeBag)
        
        donePlusButton.rx.tap
            .subscribe(onNext: { _ in
                self.completeButton.setDisable()
                self.viewModel.inputs.addDone.onNext(())
            })
            .disposed(by: disposeBag)
        
        keepPlusButton.rx.tap
            .subscribe(onNext: { _ in
                self.completeButton.setDisable()
                self.viewModel.inputs.addKeep.onNext(())
            })
            .disposed(by: disposeBag)
        
        problemPlusButton.rx.tap
            .subscribe(onNext: { _ in
                self.completeButton.setDisable()
                self.viewModel.inputs.addProblem.onNext(())
            })
            .disposed(by: disposeBag)
        
        tryPlusButton.rx.tap
            .subscribe(onNext: { _ in
                self.completeButton.setDisable()
                self.viewModel.inputs.addTry.onNext(())
            })
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe(onNext: { _ in
                self.getAllTextList()
                self.viewModel.inputs.complete.onNext(PostRetrospectRequest(done: self.doneTextList, keep: self.keepTextList, problem: self.problemTextList, attempt: self.tryTextList))
            })
            .disposed(by: disposeBag)
    }
    
    private func viewModelOutput(){
        doneTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
        
        typealias DoneTableViewDataSource
        = RxTableViewSectionedAnimatedDataSource<WriteRetrospectSection>
        
        let doneTableViewDataSource = DoneTableViewDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
            else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .bind(to: viewModel.inputs.deleteDone)
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            cell.textView.delegate = self
            
            return cell
        }
        
        viewModel.outputs.doneList
            .bind(to: doneTableView.rx.items(dataSource: doneTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.doneList
            .subscribe({ _ in
                self.doneTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.doneTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        
        typealias KeepTableViewDataSource
        = RxTableViewSectionedAnimatedDataSource<WriteRetrospectSection>
        
        let keepTableViewDataSource = KeepTableViewDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
            else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .bind(to: viewModel.inputs.deleteKeep)
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            cell.textView.delegate = self
            
            return cell
        }
        
        viewModel.outputs.keepList
            .bind(to: keepTableView.rx.items(dataSource: keepTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.keepList
            .subscribe({ _ in
                self.keepTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.keepTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        typealias ProblemTableViewDataSource
        = RxTableViewSectionedAnimatedDataSource<WriteRetrospectSection>
        
        let problemTableViewDataSource = ProblemTableViewDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
            else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .bind(to: viewModel.inputs.deleteProblem)
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            cell.textView.delegate = self
            
            return cell
        }
        
        viewModel.outputs.problemList
            .bind(to: problemTableView.rx.items(dataSource: problemTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.problemList
            .subscribe({ _ in
                self.problemTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.problemTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        typealias TryTableViewDataSource
        = RxTableViewSectionedAnimatedDataSource<WriteRetrospectSection>
        
        let tryTableViewDataSource = TryTableViewDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
            else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .bind(to: viewModel.inputs.deleteTry)
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            cell.textView.delegate = self
            
            return cell
        }
        
        viewModel.outputs.tryList
            .bind(to: tryTableView.rx.items(dataSource: tryTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.tryList
            .subscribe({ _ in
                self.tryTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.tryTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
    }
    
    private var navBar = NavBar().then { navBar in
        navBar.leftBtnItem.isHidden = false
        navBar.titleLabel.text = L10n.WriteRetrospect.title
    }
    
    private var scrollView = UIScrollView().then { view in
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var contentView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var doneTitle = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.WriteRetrospect.Done.title
    }
    
    private var doneTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        
        return view
    }()
    
    private var donePlusButton = LongButton().then { view in //MARK: - 플러스 버튼 활성화 로직 고민
        view.setTitle("", for: .normal)
        view.setBackgroundImage(Asset.icPlusButtonGray.image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFill //이미지가 꽉차게 하는 기능
    }
    
    private var keepTitle = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.WriteRetrospect.Keep.title
    }
    
    private var keepTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        
        return view
    }()
    
    private var keepPlusButton = LongButton().then { view in
        view.setTitle("", for: .normal)
        view.setBackgroundImage(Asset.icPlusButtonGray.image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFill
    }
    
    private var problemTitle = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.WriteRetrospect.Problem.title
    }
    
    private var problemTableView : UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        
        return view
    }()
    
    private var problemPlusButton = LongButton().then { view in
        view.setTitle("", for: .normal)
        view.setBackgroundImage(Asset.icPlusButtonGray.image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFill
    }
    
    private var tryTitle = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.WriteRetrospect.Done.title
    }
    
    private var tryTableView : UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        
        return view
    }()
    
    private var tryPlusButton = LongButton().then { view in
        view.setTitle("", for: .normal)
        view.setBackgroundImage(Asset.icPlusButtonGray.image, for: .normal)
        view.imageView?.contentMode = .scaleAspectFill
    }
    
    private var completeButton = LongButton().then { view in
        view.setDisable()
        view.setTitle(L10n.WriteRetrospect.Enroll.Button.title, for: .normal)
    }
    
    func isAllListNotEmpty() -> Bool {
        if isDoneListNotEmpty() && isKeepListNotEmpty() && isProblemListNotEmpty() && isTryListNotEmpty() { //내용이 모두 있음
            return true
        }
        else{ //내용이 하나라도 비어있음
            return false
        }
    }
    
    func isAllListEmpty() -> Bool {
        if isDoneListEmpty() && isKeepListEmpty() && isProblemListEmpty() && isTryListEmpty() { //내용이 모두 비어있음
            return true
        }
        else{ //내용이 하나라도 차있음
            return false
        }
    }
    
    func isDoneListNotEmpty() -> Bool {
        for index in 0..<viewModel.doneCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = doneTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func isDoneListEmpty() -> Bool {
        for index in 0..<viewModel.doneCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = doneTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if !cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func isKeepListNotEmpty() -> Bool {
        for index in 0..<viewModel.keepCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = keepTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func isKeepListEmpty() -> Bool {
        for index in 0..<viewModel.keepCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = keepTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if !cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func isProblemListNotEmpty() -> Bool {
        for index in 0..<viewModel.problemCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = problemTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func isProblemListEmpty() -> Bool {
        for index in 0..<viewModel.problemCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = problemTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if !cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func isTryListNotEmpty() -> Bool {
        for index in 0..<viewModel.tryCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = tryTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func isTryListEmpty() -> Bool {
        for index in 0..<viewModel.tryCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = tryTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if !cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func getAllTextList() {
        self.doneTextList.removeAll()
        self.keepTextList.removeAll()
        self.problemTextList.removeAll()
        self.tryTextList.removeAll()
        
        for index in 0..<viewModel.doneCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = doneTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                self.doneTextList.append(cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        

        for index in 0..<viewModel.keepCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = keepTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                self.keepTextList.append(cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        

        for index in 0..<viewModel.problemCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = problemTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                self.problemTextList.append(cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        

        for index in 0..<viewModel.tryCount {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = tryTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                self.tryTextList.append(cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
}

// MARK: - Layout

extension WriteRetrospectViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            scrollView,
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            doneTitle,
            doneTableView,
            donePlusButton,
            keepTitle,
            keepTableView,
            keepPlusButton,
            problemTitle,
            problemTableView,
            problemPlusButton,
            tryTitle,
            tryTableView,
            tryPlusButton,
            completeButton
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
        
        doneTitle.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(31)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        doneTableView.snp.makeConstraints { make in
            make.top.equalTo(doneTitle.snp.bottom).offset(15)
            make.leading.equalTo(doneTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(doneTableView.contentSize.height)
        }
        
        donePlusButton.snp.makeConstraints { make in
            make.top.equalTo(doneTableView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(doneTableView)
        }
        
        donePlusButton.snp.updateConstraints { make in
            make.height.equalTo(39)
        }
        
        keepTitle.snp.makeConstraints{ make in
            make.top.equalTo(donePlusButton.snp.bottom).offset(31)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        keepTableView.snp.makeConstraints { make in
            make.top.equalTo(keepTitle.snp.bottom).offset(15)
            make.leading.equalTo(keepTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(keepTableView.contentSize.height)
        }
        
        keepPlusButton.snp.makeConstraints { make in
            make.top.equalTo(keepTableView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(keepTableView)
        }
        
        keepPlusButton.snp.updateConstraints { make in
            make.height.equalTo(39)
        }
        
        problemTitle.snp.makeConstraints{ make in
            make.top.equalTo(keepPlusButton.snp.bottom).offset(31)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        problemTableView.snp.makeConstraints { make in
            make.top.equalTo(problemTitle.snp.bottom).offset(15)
            make.leading.equalTo(problemTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(problemTableView.contentSize.height)
        }
        
        problemPlusButton.snp.makeConstraints { make in
            make.top.equalTo(problemTableView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(problemTableView)
        }
        
        problemPlusButton.snp.updateConstraints { make in
            make.height.equalTo(39)
        }
        
        tryTitle.snp.makeConstraints{ make in
            make.top.equalTo(problemPlusButton.snp.bottom).offset(31)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        tryTableView.snp.makeConstraints { make in
            make.top.equalTo(tryTitle.snp.bottom).offset(15)
            make.leading.equalTo(tryTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(tryTableView.contentSize.height)
        }
        
        tryPlusButton.snp.makeConstraints { make in
            make.top.equalTo(tryTableView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(tryTableView)
        }
        
        tryPlusButton.snp.updateConstraints { make in
            make.height.equalTo(39)
        }
        
        completeButton.snp.makeConstraints{ make in
            make.top.equalTo(tryPlusButton.snp.bottom).offset(60)
            make.leading.equalTo(contentView.snp.leading).offset(28)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.bottom.equalTo(contentView.snp.bottom).offset(-42)
        }
    }
}

extension WriteRetrospectViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if isAllListNotEmpty() {
            completeButton.setEnable()
        }
        else {
            completeButton.setDisable()
        }
    }
}
