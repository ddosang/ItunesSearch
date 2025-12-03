//
//  BaseCollectionViewCell.swift
//  Viewer
//
//  Created by 임은지 on 2023/03/13.
//

import UIKit
import SnapKit
import Then

class BaseCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        bindConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {}
    
    func bindConstraints() {}
}
