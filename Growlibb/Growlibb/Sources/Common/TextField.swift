//
//  TextField.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/11.
//

import SnapKit
import UIKit

final class TextField: UITextField {
    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension TextField {
    private func setupViews() {
        self.backgroundColor = .veryLightGray
        self.font = .pretendardMedium14
        self.textColor = .black
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        
        self.snp.makeConstraints{ make in
            make.height.equalTo(57)
        }
    }
}
