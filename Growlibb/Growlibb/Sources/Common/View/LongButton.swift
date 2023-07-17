//
//  BottomButton.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/10.
//

import SnapKit
import UIKit

final class LongButton: UIButton {
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

extension LongButton {
    private func setupViews() {
        self.backgroundColor = .primaryBlue
        self.titleLabel?.font = .pretendardSemibold20
        self.clipsToBounds = true
        self.layer.cornerRadius = 9
        
        self.snp.makeConstraints{ make in
            make.height.equalTo(50)
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
