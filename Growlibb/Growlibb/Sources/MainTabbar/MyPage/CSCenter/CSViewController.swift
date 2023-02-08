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
                case 0:
                    break
                case 1:
                    break
                    
                case 2:
                    let vc = TermsOfUseViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    break
                    
                default:
                    let vc = PrivacyViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    break
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
