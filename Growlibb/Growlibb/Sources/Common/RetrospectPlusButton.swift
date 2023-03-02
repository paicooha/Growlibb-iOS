//
//  RetrospectPlusButton.swift
//  Growlibb
//
//  Created by 이유리 on 2023/03/03.
//

import SnapKit
import UIKit

final class RetrospectPlusButton: UIButton {
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

extension RetrospectPlusButton {
    private func setupViews() {
        self.setTitle("", for: .normal)
        self.isEnabled = false
        self.setBackgroundImage(Asset.icPlusButtonGray.image, for: .disabled)
        self.imageView?.contentMode = .scaleAspectFill
        
        self.snp.makeConstraints{ make in
            make.height.equalTo(39)
        }
    }
    
    func setEnable(){
        self.isEnabled = true
        self.setBackgroundImage(Asset.icPlusButtonBlue.image, for: .normal)
    }
    
    func setDisable(){
        self.isEnabled = false
        self.setBackgroundImage(Asset.icPlusButtonGray.image, for: .disabled)
    }
}
