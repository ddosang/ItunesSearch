//
//  ViewController.swift
//  BaseProj
//
//  Created by 임은지 on 4/3/24.
//

import UIKit

class ViewController: BaseViewController {
    
    private let nameButton: UIButton = .init().then { b in
        b.backgroundColor = .systemBlue
        b.setTitle("asdf", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func setup() {
        super.setup()
        view.addSubview(nameButton)
    }
    
    override func bindConstraints() {
        super.bindConstraints()
        
        nameButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

