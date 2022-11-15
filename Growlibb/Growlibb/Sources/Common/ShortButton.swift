//
//  CommonButton.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/14.
//

import SnapKit
import UIKit

final class ShortButton: UIButton {
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

extension ShortButton {
    private func setupViews() {
        self.titleLabel?.font = .pretendardMedium14
        self.clipsToBounds = true
        self.layer.cornerRadius = 9
        
        self.snp.makeConstraints{ make in
            make.height.equalTo(57)
        }
    }
    
    func setEnable(){
        self.isEnabled = true
        self.backgroundColor = .primaryBlue
        self.titleLabel?.textColor = .veryLightBlue
    }
    
    func setDisable(){
        self.isEnabled = false
        self.backgroundColor = .brownGray
        self.titleLabel?.textColor = .veryLightGray
    }
}
