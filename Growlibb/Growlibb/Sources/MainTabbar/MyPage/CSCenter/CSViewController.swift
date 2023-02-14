//
//  CSViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit
import SafariServices

class CSViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: CSViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: CSViewModel

    private func viewModelInput() {
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in    
                switch index.row {
                case 0: //공지사항
                    let vc = SFSafariViewController(url: URL(string: "https://plum-aster-76d.notion.site/6fe46bfb50734009ad504be0d3bda3a1")!)
                    vc.modalPresentationStyle = .overFullScreen
                    self!.present(vc, animated: true, completion: nil)
//                    vc.delegate = self
                    
                case 1: //FAQ
                    let vc = SFSafariViewController(url: URL(string: "https://plum-aster-76d.notion.site/FAQ-9017df8d6ca143edb0f30772bc312381")!)
                    vc.modalPresentationStyle = .overFullScreen
                    self!.present(vc, animated: true, completion: nil)
//                    vc.delegate = self
                    
                case 2: //잉용약관
                    let vc = SFSafariViewController(url: URL(string: "https://plum-aster-76d.notion.site/69b19922795441cfb18edd49d6f1f265")!)
                    vc.modalPresentationStyle = .overFullScreen
                    self!.present(vc, animated: true, completion: nil)
//                    vc.delegate = self
                    
                default: //개인정보처리방침
                    let vc = SFSafariViewController(url: URL(string: "https://plum-aster-76d.notion.site/c55286b8e9794522ae05bcc55cdbac13")!)
                    vc.modalPresentationStyle = .overFullScreen
                    self!.present(vc, animated: true, completion: nil)
//                    vc.delegate = self
                }
            })
            .disposed(by: disposeBag)
    }

    private func viewModelOutput(){

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
        
        typealias CsListDataSource
        = RxTableViewSectionedReloadDataSource<MyPageSection>
        
        let csListTableViewDataSource = CsListDataSource { [self] _, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.id, for: indexPath) as? MyPageCell
            else { return UITableViewCell() }
                        
            cell.label.text = item
            
            cell.preservesSuperviewLayoutMargins = false //separator 꽉 안차는 현상 해결하기 위한 코드
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
                        
            return cell
        }
        
        viewModel.outputs.csList
            .map { [MyPageSection(items: $0)]}
            .bind(to: tableView.rx.items(dataSource: csListTableViewDataSource))
            .disposed(by: disposeBag)
        
    }

    private var navBar = NavBar().then { navBar in
        navBar.leftBtnItem.isHidden = false
        navBar.rightBtnItem.isHidden = true
        navBar.titleLabel.isHidden = false
        navBar.titleLabel.text = L10n.MyPage.Cs.title
    }
    
    private var tableView = UITableView().then { view in
        view.isScrollEnabled = false
        view.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.id)
    }
}

// MARK: - Layout

extension CSViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            tableView
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
