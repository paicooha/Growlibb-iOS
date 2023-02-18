//
//  DetailRetrospectViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class DetailRetrospectViewController: BaseViewController {
    
    let dateUtil = DateUtil.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()
        
        viewModel.routeInputs.needUpdate.onNext(true)
        
        viewModelInput()
        viewModelOutput()
    }
    
    init(viewModel: DetailRetrospectViewModel, retrospectionId: Int) {
        self.viewModel = viewModel
        self.retrospectionId = retrospectionId
        super.init()
    }
    
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: DetailRetrospectViewModel
    private var retrospectionId: Int
    
    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)
        
        modifyButton.rx.tap
            .subscribe(onNext: { _ in

            })
            .disposed(by: disposeBag)
    }
    
    private func viewModelOutput(){
        
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .writtenDate
            .subscribe(onNext: { string in
                let date = DateUtil.shared.getDate(from: string, format: .yyyyMddDash)
                self.navBar.titleLabel.text = "\(self.dateUtil.formattedString(for: date ?? Date(), format: .yyMMdd)) 회고"
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.doneList
            .bind(to: doneTableView.rx.items(cellIdentifier: WriteRetrospectCell.id, cellType: WriteRetrospectCell.self)) { _, item, cell in
                
                cell.deleteButton.isHidden = true
                cell.textView.isEditable = false
                
                cell.textView.text = item.content
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.doneList
            .subscribe(onNext: { hi in
                self.doneTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.doneTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.keepList
            .bind(to: keepTableView.rx.items(cellIdentifier: WriteRetrospectCell.id, cellType: WriteRetrospectCell.self)) { _, item, cell in
                
                cell.deleteButton.isHidden = true
                cell.textView.isEditable = false
                
                cell.textView.text = item.content
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.keepList
            .subscribe({ _ in
                self.keepTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.keepTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.problemList
            .bind(to: problemTableView.rx.items(cellIdentifier: WriteRetrospectCell.id, cellType: WriteRetrospectCell.self)) { _, item, cell in
                
                cell.deleteButton.isHidden = true
                cell.textView.isEditable = false
                
                cell.textView.text = item.content
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.problemList
            .subscribe({ _ in
                self.problemTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.problemTableView.contentSize.height) //스크롤뷰 높이 늘리기
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.tryList
            .bind(to: tryTableView.rx.items(cellIdentifier: WriteRetrospectCell.id, cellType: WriteRetrospectCell.self)) { _, item, cell in
                
                cell.deleteButton.isHidden = true
                cell.textView.isEditable = false
                
                cell.textView.text = item.content
            }
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
//        navBar.titleLabel.text = L10n.WriteRetrospect.title
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
    
    private var modifyButton = LongButton().then { view in
        view.setEnable()
        view.setTitle(L10n.Edit.title, for: .normal)
    }
}

// MARK: - Layout

extension DetailRetrospectViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            scrollView,
            modifyButton,
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            doneTitle,
            doneTableView,
            keepTitle,
            keepTableView,
            problemTitle,
            problemTableView,
            tryTitle,
            tryTableView,
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
            make.bottom.equalTo(modifyButton.snp.top).offset(-20)
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
        
        keepTitle.snp.makeConstraints{ make in
            make.top.equalTo(doneTableView.snp.bottom).offset(40)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        keepTableView.snp.makeConstraints { make in
            make.top.equalTo(keepTitle.snp.bottom).offset(15)
            make.leading.equalTo(keepTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(keepTableView.contentSize.height)
        }
        
        problemTitle.snp.makeConstraints{ make in
            make.top.equalTo(keepTableView.snp.bottom).offset(40)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        problemTableView.snp.makeConstraints { make in
            make.top.equalTo(problemTitle.snp.bottom).offset(15)
            make.leading.equalTo(problemTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(problemTableView.contentSize.height)
        }
        
        tryTitle.snp.makeConstraints{ make in
            make.top.equalTo(problemTableView.snp.bottom).offset(40)
            make.leading.equalTo(contentView.snp.leading).offset(28)
        }
        
        tryTableView.snp.makeConstraints { make in
            make.top.equalTo(tryTitle.snp.bottom).offset(15)
            make.leading.equalTo(tryTitle.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.height.equalTo(tryTableView.contentSize.height)
        }
        
        modifyButton.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom).offset(-42)
        }
    }
}
