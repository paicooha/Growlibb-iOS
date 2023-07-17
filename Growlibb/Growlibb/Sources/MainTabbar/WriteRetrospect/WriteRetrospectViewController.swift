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
                self.donePlusButton.setDisable() //처음에 내용이 비워져있기 때문에 비활성화
                self.completeButton.setDisable()
                self.viewModel.inputs.addDone.onNext(())
            })
            .disposed(by: disposeBag)
        
        keepPlusButton.rx.tap
            .subscribe(onNext: { _ in
                self.keepPlusButton.setDisable()
                self.completeButton.setDisable()
                self.viewModel.inputs.addKeep.onNext(())
            })
            .disposed(by: disposeBag)
        
        problemPlusButton.rx.tap
            .subscribe(onNext: { _ in
                self.problemPlusButton.setDisable()
                self.completeButton.setDisable()
                self.viewModel.inputs.addProblem.onNext(())
            })
            .disposed(by: disposeBag)
        
        tryPlusButton.rx.tap
            .subscribe(onNext: { _ in
                self.tryPlusButton.setDisable()
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
            
            cell.delegate = self
            cell.textView.text = ""
            
            cell.deleteButton.rx.tap
                .subscribe(onNext: { _ in
                    self.controlButtonByIsEmptyList("done")

                    guard self.doneTableView.indexPath(for: cell) != nil else { return }
                    self.viewModel.inputs.deleteDone.onNext(self.doneTableView.indexPath(for: cell)!.row)
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
                        
            return cell
        }
        
        viewModel.outputs.doneList
            .bind(to: doneTableView.rx.items(dataSource: doneTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.doneList
            .subscribe({ _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    self.doneTableView.snp.updateConstraints { make in            make.height.greaterThanOrEqualTo(self.doneTableView.contentSize.height)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        
        typealias KeepTableViewDataSource
        = RxTableViewSectionedAnimatedDataSource<WriteRetrospectSection>
        
        let keepTableViewDataSource = KeepTableViewDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
            else { return UITableViewCell() }
            
            cell.delegate = self
            cell.textView.text = ""
            
            cell.deleteButton.rx.tap
                .subscribe(onNext: { _ in
                    self.controlButtonByIsEmptyList("keep")
                    
                    guard (self.keepTableView.indexPath(for: cell) != nil) else { return } //삭제 버튼을 빠르게 눌렀을 때 cell의 인덱스를 nil로 인식하는 부분 방지를 위해 guard침
                    self.viewModel.inputs.deleteKeep.onNext(self.keepTableView.indexPath(for: cell)!.row)
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
                        
            return cell
        }
        
        viewModel.outputs.keepList
            .bind(to: keepTableView.rx.items(dataSource: keepTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.keepList
            .subscribe({ _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    self.keepTableView.snp.updateConstraints { make in            make.height.greaterThanOrEqualTo(self.keepTableView.contentSize.height)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        typealias ProblemTableViewDataSource
        = RxTableViewSectionedAnimatedDataSource<WriteRetrospectSection>
        
        let problemTableViewDataSource = ProblemTableViewDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
            else { return UITableViewCell() }
            
            cell.delegate = self
            cell.textView.text = ""
            
            cell.deleteButton.rx.tap
                .subscribe(onNext: { _ in
                    self.controlButtonByIsEmptyList("problem")
                    
                    guard (self.problemTableView.indexPath(for: cell) != nil) else { return }
                    self.viewModel.inputs.deleteProblem.onNext(self.problemTableView.indexPath(for: cell)!.row)
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
                        
            return cell
        }
        
        viewModel.outputs.problemList
            .bind(to: problemTableView.rx.items(dataSource: problemTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.problemList
            .subscribe({ _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    self.problemTableView.snp.updateConstraints { make in            make.height.greaterThanOrEqualTo(self.problemTableView.contentSize.height)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        typealias TryTableViewDataSource
        = RxTableViewSectionedAnimatedDataSource<WriteRetrospectSection>
        
        let tryTableViewDataSource = TryTableViewDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
            else { return UITableViewCell() }
            
            cell.delegate = self
            cell.textView.text = ""
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .subscribe(onNext: { index in
                    self.controlButtonByIsEmptyList("try")
                    
                    guard (self.tryTableView.indexPath(for: cell) != nil) else { return }
                    self.viewModel.inputs.deleteTry.onNext(self.tryTableView.indexPath(for: cell)!.row)
                    
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
                        
            return cell
        }
        
        viewModel.outputs.tryList
            .bind(to: tryTableView.rx.items(dataSource: tryTableViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.tryList
            .subscribe({ _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    self.tryTableView.snp.updateConstraints { make in            make.height.greaterThanOrEqualTo(self.tryTableView.contentSize.height)
                    }
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
    
    private var doneTableView: RetrospectTableView = {
        let view = RetrospectTableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    private var donePlusButton = RetrospectPlusButton()
    
    private var keepTitle = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.WriteRetrospect.Keep.title
    }
    
    private var keepTableView: RetrospectTableView = {
        let view = RetrospectTableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        
        return view
    }()
    
    private var keepPlusButton = RetrospectPlusButton()
    
    private var problemTitle = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.WriteRetrospect.Problem.title
    }
    
    private var problemTableView : RetrospectTableView = {
        let view = RetrospectTableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    private var problemPlusButton = RetrospectPlusButton()
    
    private var tryTitle = UILabel().then { view in
        view.font = .pretendardSemibold16
        view.text = L10n.WriteRetrospect.Try.title
    }
    
    private var tryTableView : RetrospectTableView = {
        let view = RetrospectTableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.register(WriteRetrospectCell.self, forCellReuseIdentifier: WriteRetrospectCell.id)
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    private var tryPlusButton = RetrospectPlusButton()
    
    private var completeButton = LongButton().then { view in
        view.setDisable()
        view.setTitle(L10n.WriteRetrospect.Enroll.Button.title, for: .normal)
    }
    
    func controlButtonByIsEmptyList(_ type: String) {
        switch type {
        case "done":
            self.isDoneListEmpty() ? self.donePlusButton.setDisable() : self.donePlusButton.setEnable()
        case "keep":
            self.isKeepListEmpty() ? self.keepPlusButton.setDisable() : self.keepPlusButton.setEnable()
        case "problem":
            self.isProblemListEmpty() ? self.problemPlusButton.setDisable() : self.problemPlusButton.setEnable()
        case "try":
            self.isTryListEmpty() ? self.tryPlusButton.setDisable() : self.tryPlusButton.setEnable()
        default:
            break
        }
        
        self.isAllListNotEmpty() ? self.completeButton.setEnable() : self.completeButton.setDisable()
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
        for index in 0..<self.viewModel.outputs.doneList.value[0].items.count {
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
        for index in 0..<self.viewModel.outputs.doneList.value[0].items.count {
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
        for index in 0..<self.viewModel.outputs.keepList.value[0].items.count {
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
        for index in 0..<self.viewModel.outputs.keepList.value[0].items.count {
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
        for index in 0..<self.viewModel.outputs.problemList.value[0].items.count {
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
        for index in 0..<self.viewModel.outputs.problemList.value[0].items.count {
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
        for index in 0..<self.viewModel.outputs.tryList.value[0].items.count {
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
        for index in 0..<self.viewModel.outputs.tryList.value[0].items.count {
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
        
        for index in 0..<self.viewModel.outputs.doneList.value[0].items.count {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = doneTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                self.doneTextList.append(cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        

        for index in 0..<self.viewModel.outputs.keepList.value[0].items.count {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = keepTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                self.keepTextList.append(cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        

        for index in 0..<self.viewModel.outputs.doneList.value[0].items.count {
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
            make.height.greaterThanOrEqualTo(doneTableView.contentSize.height)
        }
        
        donePlusButton.snp.makeConstraints { make in
            make.top.equalTo(doneTableView.snp.bottom)
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
            make.height.greaterThanOrEqualTo(keepTableView.contentSize.height)
        }
        
        keepPlusButton.snp.makeConstraints { make in
            make.top.equalTo(keepTableView.snp.bottom)
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
            make.height.greaterThanOrEqualTo(problemTableView.contentSize.height)
        }
        
        problemPlusButton.snp.makeConstraints { make in
            make.top.equalTo(problemTableView.snp.bottom)
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
            make.height.greaterThanOrEqualTo(tryTableView.contentSize.height)
        }
        
        tryPlusButton.snp.makeConstraints { make in
            make.top.equalTo(tryTableView.snp.bottom)
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

extension WriteRetrospectViewController: TextViewDelegate {
    func textViewDidChange(_ cell: WriteRetrospectCell, _ textView: UITextView) {
        //셀 텍스트뷰 길이에 맞게 늘어나도록
        if cell.tableView! == doneTableView {
            if isDoneListNotEmpty() { //내용이 모두 차있을 때
                donePlusButton.setEnable()
                
                if isAllListNotEmpty() {
                    completeButton.setEnable()
                }
                else{
                    completeButton.setDisable()
                }
            }
            else{
                donePlusButton.setDisable()
                completeButton.setDisable()
            }
            
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = doneTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
            
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                doneTableView.performBatchUpdates({
                    doneTableView.snp.updateConstraints { make in
                        make.height.greaterThanOrEqualTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
        else if cell.tableView! == keepTableView {
            if isKeepListNotEmpty() { //내용이 모두 차있을 때
                keepPlusButton.setEnable()
                
                if isAllListNotEmpty() {
                    completeButton.setEnable()
                }
                else{
                    completeButton.setDisable()
                }
            }
            else{
                keepPlusButton.setDisable()
                completeButton.setDisable()
            }
            
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = keepTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))

            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                keepTableView.performBatchUpdates({
                    keepTableView.snp.updateConstraints { make in
                        make.height.greaterThanOrEqualTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
        else if cell.tableView! == problemTableView {
            if isProblemListNotEmpty() { //내용이 모두 차있을 때
                problemPlusButton.setEnable()
                
                if isAllListNotEmpty() {
                    completeButton.setEnable()
                }
                else{
                    completeButton.setDisable()
                }
            }
            else{
                problemPlusButton.setDisable()
                completeButton.setDisable()
            }
            
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = problemTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
            
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                problemTableView.performBatchUpdates({
                    problemTableView.snp.updateConstraints { make in
                        make.height.greaterThanOrEqualTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
        else {
            if isTryListNotEmpty() { //내용이 모두 차있을 때
                tryPlusButton.setEnable()
                
                if isAllListNotEmpty() {
                    completeButton.setEnable()
                }
                else{
                    completeButton.setDisable()
                }
            }
            else{
                tryPlusButton.setDisable()
                completeButton.setDisable()
            }
            
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = tryTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
            
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                tryTableView.performBatchUpdates({
                    tryTableView.snp.updateConstraints { make in
                        make.height.greaterThanOrEqualTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
        
        //모두 내용이 차있는지 확인
        if isAllListNotEmpty() {
            completeButton.setEnable()
        }
        else {
            completeButton.setDisable()
        }
    }
}
