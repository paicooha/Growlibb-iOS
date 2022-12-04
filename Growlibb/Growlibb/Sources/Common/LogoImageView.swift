//
//  LogoImageView.swift
//  Growlibb
//
//  Created by 이유리 on 2022/12/04.
//

import SnapKit
import UIKit

final class LogoImageView: UIImageView {
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

extension LogoImageView {
    private func setupViews() {
        self.image = Asset.icGrowlibbLogo.image
        
        self.snp.makeConstraints{ make in
            make.width.equalTo(39)
            make.height.equalTo(42)
        }
    }
}
