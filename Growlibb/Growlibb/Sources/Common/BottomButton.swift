//
//  BottomButton.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/10.
//

import SnapKit
import UIKit

final class BottomButton: UIButton {
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

extension BottomButton {
    private func setupViews() {
        self.backgroundColor = .primaryBlue
        self.titleLabel?.font = .pretendardSemibold20
        self.clipsToBounds = true
        self.layer.cornerRadius = 9
        
        self.snp.makeConstraints{ make in
            make.height.equalTo(50)
        }
    }
}
