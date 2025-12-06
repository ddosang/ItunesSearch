//
//  RecentSearchTableViewCell.swift
//  ItunesSearch
//
//  Created by 임은지 on 12/6/25.
//

import Foundation
import UIKit

class RecentSearchTableViewCell: BaseTableViewCell {
    private let titleLabel: UILabel = .init().then { l in
        l.textColor = .black
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    override func setup() {
        contentView.addSubview(titleLabel)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
