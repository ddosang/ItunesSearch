//
//  ViewController.swift
//  BaseProj
//
//  Created by 임은지 on 4/3/24.
//

import UIKit

class ViewController: BaseViewController {
    
    // MARK: - Data
    
    private let recentSearchList: [String] = ["ta1", "ta2", "ta3", "test1", "test2", "test3", "asdf1", "asdf2", "asdf3", "aqwer"]
    private lazy var currentRecentSearchList: [String] = recentSearchList
    
    
    // MARK: - View
    
    private let searchField: UITextField = .init().then { v in
        v.placeholder = "search"
        v.backgroundColor = .lightGray
        v.textColor = .white
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        v.leftViewMode = .always
    }
    
    private let recentTableView: UITableView = .init().then { v in
        v.backgroundColor = .white
        v.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
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

// MARK: - View Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - navigation
extension ViewController {
    func goToSearchResult(searchWord: String) {
        let vc = SearchResultViewController(text: searchWord)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Delgate
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 251206
        // textField.text 는 키보드 입력 전에 들어가 있는 값이 나오고,
        // 현재 입력되는 값이 string 으로 옴. -> textField.text + string 하면 되겠네 했는데
        // backspace 를 입력하는 경우에는 "" 으로 오기 떄문에 range 값을 이용해서 replace 해야함.
        let input = NSString(string: textField.text ?? "")
        let output = input.replacingCharacters(in: range, with: string)
        print("textField: \(input), current: \(output))")
        
        currentRecentSearchList = recentSearchList.filter { $0.contains(output) }
        recentTableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            // TODO: - 검색어를 입력해주세요 토스트 (개선)
            return true
        }
        goToSearchResult(searchWord: text)
        return true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRecentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier) as? RecentSearchTableViewCell {
            cell.setTitle(currentRecentSearchList[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let text = currentRecentSearchList[indexPath.row]
        searchField.text = text
        goToSearchResult(searchWord: text)
    }
}
