//
//  WriteRetrospectTutorialCell.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/25.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class WriteRetrospectTutorialCell: UICollectionViewCell {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        initialLayout()
    }

    var imageView = UIImageView()

    private func setup() {
        contentView.addSubviews([
            imageView
        ])
    }

    private func initialLayout() {
        imageView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

extension WriteRetrospectTutorialCell {
    static let id = "\(WriteRetrospectTutorialCell.self)"
}
