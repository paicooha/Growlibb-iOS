//
//  EditRetrospectViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class EditRetrospectViewController: BaseViewController {
    var originalDoneList = [Attempt]()
    var originalKeepList = [Attempt]()
    var originalProblemList = [Attempt]()
    var originalTryList = [Attempt]()
    
    var doneList = [Attempt]()
    var keepList = [Attempt]()
    var tryList = [Attempt]()
    var problemList = [Attempt]()
    
    var editedDoneList = [RetrospectItem]()
    var editedKeepList = [RetrospectItem]()
    var editedTryList = [RetrospectItem]()
    var editedProblemList = [RetrospectItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()
        
        viewModelInput()
        viewModelOutput()
        
        viewModel.routeInputs.needUpdate.onNext(true)
        
        doneTableView.dataSource = self
        doneTableView.delegate = self
        
        keepTableView.dataSource = self
        keepTableView.delegate = self
        
        problemTableView.dataSource = self
        problemTableView.delegate = self
        
        tryTableView.dataSource = self
        tryTableView.delegate = self
    }
    
    init(viewModel: EditRetrospectViewModel,
         retrospectionId: Int) {
        self.viewModel = viewModel
        self.retrospectionId = retrospectionId
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: EditRetrospectViewModel
    private var retrospectionId: Int
    
    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)
        
        donePlusButton.rx.tap
            .subscribe(onNext: { _ in
//                self.completeButton.setDisable()
                self.doneList.append(Attempt(id: nil, content: ""))
                print(self.doneList.count)
                self.doneTableView.insertRows(at: [IndexPath(row: self.doneList.count-1, section: 0)], with: .fade)
                
                self.doneTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.doneTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        keepPlusButton.rx.tap
            .subscribe(onNext: { _ in
//                self.completeButton.setDisable()
                self.keepList.append(Attempt(id: nil, content: ""))
                self.keepTableView.insertRows(at: [IndexPath(row: self.keepList.count-1, section: 0)], with: .fade)
                
                self.keepTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.keepTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        problemPlusButton.rx.tap
            .subscribe(onNext: { _ in
//                self.completeButton.setDisable()
                self.problemList.append(Attempt(id: nil, content: ""))
                self.problemTableView.insertRows(at: [IndexPath(row: self.problemList.count-1, section: 0)], with: .fade)
                
                self.problemTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.problemTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        tryPlusButton.rx.tap
            .subscribe(onNext: { _ in
//                self.completeButton.setDisable()
                self.tryList.append(Attempt(id: nil, content: ""))
                self.tryTableView.insertRows(at: [IndexPath(row: self.problemList.count-1, section: 0)], with: .fade)
                
                self.tryTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.tryTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe(onNext: { _ in
                self.getEditedList()
                print(self.editedKeepList)
                print(self.editedProblemList)
                print(self.editedTryList)
                print(self.editedDoneList)
                self.viewModel.inputs.complete.onNext(PatchRetrospectRequest(id: self.retrospectionId, done: self.editedDoneList, keep: self.editedKeepList, problem: self.editedProblemList, attempt: self.editedTryList))
            })
            .disposed(by: disposeBag)
    }
    
    private func viewModelOutput(){
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)

        
        viewModel.outputs.doneList
            .subscribe(onNext: { list in
                self.originalDoneList.append(contentsOf: list)
                self.doneList.append(contentsOf: list)
                self.doneTableView.reloadData()
                
                self.doneTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.doneTableView.contentSize.height)
                }
            })
            .disposed(by: disposeBag)

        
        viewModel.outputs.keepList
            .subscribe(onNext: { list in
                self.originalKeepList.append(contentsOf: list)
                self.keepList.append(contentsOf: list)
                self.keepTableView.reloadData()
                
                self.keepTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.keepTableView.contentSize.height)
                }
            })
            .disposed(by: disposeBag)
        
        
        viewModel.outputs.problemList
            .subscribe(onNext: { list in
                self.originalProblemList.append(contentsOf: list)
                self.problemList.append(contentsOf: list)
                self.problemTableView.reloadData()
                
                self.problemTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.problemTableView.contentSize.height)
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.tryList
            .subscribe(onNext: { list in
                self.originalTryList.append(contentsOf: list)
                self.tryList.append(contentsOf: list)
                self.tryTableView.reloadData()
                
                self.tryTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.tryTableView.contentSize.height)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private var navBar = NavBar().then { navBar in
        navBar.leftBtnItem.isHidden = false
        navBar.titleLabel.text = L10n.Retrospect.Edit.title
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
        view.text = L10n.WriteRetrospect.Try.title
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
//        view.setDisable()
        view.setTitle(L10n.Edit.title, for: .normal)
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
        for index in 0..<doneList.count {
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
        for index in 0..<doneList.count {
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
        for index in 0..<keepList.count {
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
        for index in 0..<keepList.count {
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
        for index in 0..<problemList.count {
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
        for index in 0..<problemList.count {
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
        for index in 0..<tryList.count {
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
        for index in 0..<tryList.count {
            let indexpath = IndexPath(row: index, section: 0)
            if let cell = tryTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                if !cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }

    func getEditedList(){
        //새로운 내용 추가
        for index in 0..<doneList.count {
            if self.doneList[index].id == nil {
                let indexpath = IndexPath(row: index, section: 0)
                if let cell = doneTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                    
                    self.editedDoneList.append(RetrospectItem(content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            }
        }
        
        //이미있는 항목 중 수정된 항목
        for i in 0..<doneList.count {
            for j in 0..<originalDoneList.count {
                if doneList[i].id == originalDoneList[j].id { // 이미 있는 항목
                    let indexpath = IndexPath(row: i, section: 0)
                    if let cell = doneTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                            
                        if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != originalDoneList[j].content { //수정된 경우
                            self.editedDoneList.append(RetrospectItem(id: originalDoneList[j].id, content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines), deletionStatus: "N"))
                        }
                        else{ //수정 안한 경우
                            self.editedDoneList.append(RetrospectItem(id: originalDoneList[j].id, content: originalDoneList[j].content, deletionStatus: "N"))
                        }
                    }
                }
            }
        }
        
        //새로운 내용 추가
        for index in 0..<keepList.count {
            if self.keepList[index].id == nil {
                let indexpath = IndexPath(row: index, section: 0)
                if let cell = keepTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                    
                    self.editedKeepList.append(RetrospectItem(content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            }
        }
        
        //이미있는 항목 중 수정된 항목
        for i in 0..<keepList.count {
            for j in 0..<originalKeepList.count {
                if keepList[i].id == originalKeepList[j].id { // 이미 있는 항목
                    let indexpath = IndexPath(row: i, section: 0)
                    if let cell = keepTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                            
                        if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != originalKeepList[j].content { //수정된 경우
                            self.editedKeepList.append(RetrospectItem(id: originalKeepList[j].id, content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines), deletionStatus: "N"))
                        }
                        else{ //수정 안한 경우
                            self.editedKeepList.append(RetrospectItem(id: originalKeepList[j].id, content: originalKeepList[j].content, deletionStatus: "N"))
                        }
                    }
                }
            }
        }
        
        //새로운 내용 추가
        for index in 0..<problemList.count {
            if self.problemList[index].id == nil {
                let indexpath = IndexPath(row: index, section: 0)
                if let cell = problemTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                    
                    self.editedProblemList.append(RetrospectItem(content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            }
        }
        
        //이미있는 항목 중 수정된 항목
        for i in 0..<problemList.count {
            for j in 0..<originalProblemList.count {
                if problemList[i].id == originalProblemList[j].id { // 이미 있는 항목
                    let indexpath = IndexPath(row: i, section: 0)
                    if let cell = problemTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                            
                        if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != originalProblemList[j].content { //수정된 경우
                            self.editedProblemList.append(RetrospectItem(id: originalProblemList[j].id, content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines), deletionStatus: "N"))
                        }
                        else{ //수정 안한 경우
                            self.editedProblemList.append(RetrospectItem(id: originalProblemList[j].id, content: originalProblemList[j].content, deletionStatus: "N"))
                        }
                    }
                }
            }
        }
        
        //새로운 내용 추가
        for index in 0..<tryList.count {
            if self.tryList[index].id == nil {
                let indexpath = IndexPath(row: index, section: 0)
                if let cell = tryTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                    
                    self.editedTryList.append(RetrospectItem(content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            }
        }
        
        //이미있는 항목 중 수정된 항목
        for i in 0..<tryList.count {
            for j in 0..<originalTryList.count {
                if tryList[i].id == originalTryList[j].id { // 이미 있는 항목
                    let indexpath = IndexPath(row: i, section: 0)
                    if let cell = tryTableView.cellForRow(at: indexpath) as? WriteRetrospectCell {
                            
                        if cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != originalTryList[j].content { //수정된 경우
                            self.editedTryList.append(RetrospectItem(id: originalTryList[j].id, content: cell.textView.text.trimmingCharacters(in: .whitespacesAndNewlines), deletionStatus: "N"))
                        }
                        else{ //수정 안한 경우
                            self.editedTryList.append(RetrospectItem(id: originalTryList[j].id, content: originalTryList[j].content, deletionStatus: "N"))
                        }
                    }
                }
            }
        }
        
    }
}

// MARK: - Layout

extension EditRetrospectViewController {
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

extension EditRetrospectViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        if isAllListNotEmpty() {
//            completeButton.setEnable()
//        }
//        else {
//            completeButton.setDisable()
//        }
    }
}

extension EditRetrospectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == doneTableView {
            return doneList.count
        }
        else if tableView == keepTableView {
            return keepList.count
        }
        else if tableView == problemTableView {
            return problemList.count
        }
        else {
            return tryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WriteRetrospectCell.id, for: indexPath) as? WriteRetrospectCell
        else { return UITableViewCell() }
        
        cell.delegate = self
        
        if tableView == doneTableView {
            cell.textView.text = doneList[indexPath.row].content
            cell.id = doneList[indexPath.row].id ?? 0
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .subscribe(onNext: { index in
                    if self.doneList[index].id != nil {
                        self.editedDoneList.append(RetrospectItem(id: self.doneList[index].id, content:self.doneList[index].content, deletionStatus: "Y"))
                    }
                    
                    self.doneList.remove(at: index)
                    self.doneTableView.deleteRows(at: [IndexPath(row: index, section:0)], with: .fade)
                    self.doneTableView.snp.updateConstraints { make in
                        make.height.equalTo(self.doneTableView.contentSize.height)
                    }
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            return cell
        }
        else if tableView == keepTableView {
            cell.textView.text = keepList[indexPath.row].content
            cell.id = keepList[indexPath.row].id ?? 0
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .subscribe(onNext: { index in
                    if self.keepList[index].id != nil {
                        self.editedKeepList.append(RetrospectItem(id: self.keepList[index].id, content:self.keepList[index].content, deletionStatus: "Y"))
                    }
                    
                    self.keepList.remove(at: index)
                    self.keepTableView.deleteRows(at: [IndexPath(row: index, section:0)], with: .fade)
                    self.keepTableView.snp.updateConstraints { make in
                        make.height.equalTo(self.keepTableView.contentSize.height)
                    }
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            return cell
        }
        else if tableView == problemTableView {
            cell.textView.text = problemList[indexPath.row].content
            cell.id = problemList[indexPath.row].id ?? 0

            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .subscribe(onNext: { index in
                    if self.problemList[index].id != nil {
                        self.editedProblemList.append(RetrospectItem(id: self.problemList[index].id, content:self.problemList[index].content, deletionStatus: "Y"))
                    }
                    
                    self.problemList.remove(at: index)
                    self.problemTableView.deleteRows(at: [IndexPath(row: index, section:0)], with: .fade)
                    self.problemTableView.snp.updateConstraints { make in
                        make.height.equalTo(self.problemTableView.contentSize.height)
                    }
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            return cell
        }
        else {
            cell.textView.text = tryList[indexPath.row].content
            cell.id = tryList[indexPath.row].id
            
            cell.deleteButton.rx.tap
                .map { indexPath.row }
                .subscribe(onNext: { index in
                    if self.tryList[index].id != nil {
                        self.editedTryList.append(RetrospectItem(id: self.tryList[index].id, content:self.tryList[index].content, deletionStatus: "Y"))
                    }
                    
                    self.tryList.remove(at: index)
                    self.tryTableView.deleteRows(at: [IndexPath(row: index, section:0)], with: .fade)
                    self.tryTableView.snp.updateConstraints { make in
                        make.height.equalTo(self.tryTableView.contentSize.height)
                    }
                })
                .disposed(by: cell.disposeBag)
            
            if indexPath.row != 0 {
                cell.deleteButton.isHidden = false
            }
            
            return cell
        }
    }
}

extension EditRetrospectViewController: TextViewDelegate {
    func updateTextViewHeight(_ cell: WriteRetrospectCell, _ textView: UITextView) {
        if cell.tableView! == doneTableView {
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = doneTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
            cell.backGround.snp.updateConstraints { make in
                make.height.equalTo(size.height)
            }
            
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                doneTableView.performBatchUpdates({
                    doneTableView.snp.updateConstraints { make in
                        make.height.equalTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
        else if cell.tableView! == keepTableView {
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = keepTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
            cell.backGround.snp.updateConstraints { make in
                make.height.equalTo(size.height)
            }
            
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                keepTableView.performBatchUpdates({
                    keepTableView.snp.updateConstraints { make in
                        make.height.equalTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
        else if cell.tableView! == problemTableView {
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = problemTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
            cell.backGround.snp.updateConstraints { make in
                make.height.equalTo(size.height)
            }
            
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                problemTableView.performBatchUpdates({
                    problemTableView.snp.updateConstraints { make in
                        make.height.equalTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
        else {
            let size = textView.sizeThatFits(textView.bounds.size)
            let newSize = tryTableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
            cell.backGround.snp.updateConstraints { make in
                make.height.equalTo(size.height)
            }
            
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                tryTableView.performBatchUpdates({
                    tryTableView.snp.updateConstraints { make in
                        make.height.equalTo(newSize)
                    }
                })
                UIView.setAnimationsEnabled(true)
            }
        }
    }
}
