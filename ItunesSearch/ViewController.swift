//
//  ViewController.swift
//  BaseProj
//
//  Created by 임은지 on 4/3/24.
//

import UIKit

class ViewController: BaseViewController {
    
    private let searchField: UITextField = .init().then { v in
        v.placeholder = "search"
        v.backgroundColor = .lightGray
        v.textColor = .white
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        v.leftViewMode = .always
    }
    
    private let recentTableView: UITableView = .init().then { v in
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func setup() {
        super.setup()
        
        searchField.delegate = self
        recentTableView.delegate = self
        recentTableView.dataSource = self
        
        view.addSubview(searchField)
        view.addSubview(recentTableView)
    }
    
    override func bindConstraints() {
        super.bindConstraints()
        
        searchField.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        recentTableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension ViewController: UITextFieldDelegate {
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let l = UILabel()
        l.text = "test"
        
        let cell = UITableViewCell()
        cell.contentView.addSubview(l)
        
        l.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
    
    
}
