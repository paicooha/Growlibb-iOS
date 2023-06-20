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
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        dismissKeyboardWhenTappedAround()
    }
}

// MARK: - Base Functions

extension BaseViewController: UIGestureRecognizerDelegate {
    func setBackgroundColor() {
        view.backgroundColor = .white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    func dismissKeyboardWhenTappedAround() {
        let tap =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false //같은 뷰에 여러 tap gesture가 있을 때, 해당 tap이 다른 tap을 방해하지 않기 위한 설정
        view.addGestureRecognizer(tap)
        print("VC tapped")
    }

    @objc func dismissKeyboard() {
        view.endEditing(false)
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldBeRequiredToFailBy _: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) { //10글자 제한
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
}
