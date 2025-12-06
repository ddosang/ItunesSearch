//
//  BaseTableViewCell.swift
//  Viewer
//
//  Created by 임은지 on 2023/03/13.
//

import UIKit
import SnapKit
import Then

class BaseTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        bindConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        bindConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {}
    
    func bindConstraints() {}
}
