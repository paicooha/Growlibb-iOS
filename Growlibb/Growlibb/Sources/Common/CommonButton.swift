//
//  CommonButton.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/14.
//

import SnapKit
import UIKit

final class CommonButton: UIButton {
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

extension CommonButton {
    private func setupViews() {
        self.backgroundColor = .primaryBlue
        self.titleLabel?.font = .pretendardMedium14
        
        self.snp.makeConstraints{ make in
            make.height.equalTo(57)
        }
    }
}
