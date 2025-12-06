//
//  BaseViewController.swift
//  Viewer
//
//  Created by 임은지 on 2023/03/13.
//

import UIKit
import SnapKit
import Then

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    static var identifier: String {
        return String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNaviation()
        setup()
        bindConstraints()
    }
    
    func setUpNaviation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func bindConstraints() {}

}
