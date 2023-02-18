//
//  ViewRetrospectViewController.swift
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

class RetrospectListViewController: BaseViewController {
    
    var retrospectList = [Retrospection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()
        
        viewModelInput()
        viewModelOutput()
        
        retrospectTableView.dataSource = self
        retrospectTableView.delegate = self
        
        retrospectTableView.rx.prefetchRows
            .compactMap(\.last?.row)
            .withUnretained(self)
            .bind { ss, row in
              guard row == ss.retrospectList.count - 1 else { return }
                self.viewModel.routeInputs.needUpdate.onNext(true)
            }
            .disposed(by: disposeBag)
    }
    
    init(viewModel: RetrospectListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: RetrospectListViewModel
    
    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: self.viewModel.routes.backward)
            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
    }
    
    private func viewModelOutput(){
        
        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.retrospectList
            .filter {
                if $0 != nil { //회고리스트가 하나라도 있을 경우 아래로 넘김
                    return true
                }
                else{
                    return false
                }
            }
            .subscribe(onNext: { list in
                self.retrospectList.append(contentsOf: list!)
                self.retrospectTableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.retrospectTableView.performBatchUpdates(nil, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private var navBar = NavBar().then { navBar in
        navBar.leftBtnItem.isHidden = false
        navBar.titleLabel.text = L10n.MyPage.List.retrospect
    }
    
    private var indicator = UIActivityIndicatorView()
    
    private var retrospectTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(RetrospectListCell.self, forCellReuseIdentifier: RetrospectListCell.id)
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
}

// MARK: - Layout

extension RetrospectListViewController {
    private func setupViews() {
        retrospectTableView.tableFooterView = indicator
        retrospectTableView.tableFooterView?.isHidden = true
        
        view.addSubviews([
            navBar,
            retrospectTableView
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        retrospectTableView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(30)
            make.leading.equalTo(view.snp.leading).offset(28)
            make.trailing.equalTo(view.snp.trailing).offset(-28)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
}

extension RetrospectListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      self.retrospectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      (tableView.dequeueReusableCell(withIdentifier: RetrospectListCell.id, for: indexPath) as! RetrospectListCell).then { view in
          view.prepare(dateString: self.retrospectList[indexPath.row].writtenDate)
      }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.inputs.goDetail.onNext(retrospectList[indexPath.row].id)
    }
}
