//
//  BaseViewController.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/02.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BaseViewController: UIViewController {
    // MARK: Lifecycle
    init() {
        Log.d(tag: .lifeCycle, "VC Initialized")
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder? = nil) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        Log.d(tag: .lifeCycle, "VC Deinitialized")
    }

    // MARK: Internal

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        dismissKeyboardWhenTappedAround()
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) { //10글자 제한
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
}

// MARK: - Base Functions

extension BaseViewController: UIGestureRecognizerDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    func dismissKeyboardWhenTappedAround() {
        let tap =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(false)
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldBeRequiredToFailBy _: UIGestureRecognizer) -> Bool {
        return true
    }
}
