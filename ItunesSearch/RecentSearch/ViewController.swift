//
//  ViewController.swift
//  BaseProj
//
//  Created by 임은지 on 4/3/24.
//

import UIKit

class ViewController: BaseViewController {
    
    // MARK: - Data
    private var recentSearchList: [String] = ["taeyeon", "yoona", "wendy", "asepa", "손예진", "김태연", "test1", "test2", "test3", "asdf1", "asdf2", "asdf3", "aqwer"] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private lazy var currentRecentSearchList: [String] = recentSearchList
    
    var trackList: [Track] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var isFocusOnSearchField: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var cache: [String: [Track]] = [:]
    
    // MARK: - View
    private let searchField: UITextField = .init().then { v in
        v.placeholder = "search"
        v.backgroundColor = .lightGray
        v.textColor = .white
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        v.leftViewMode = .always
    }
    
    private let tableView: UITableView = .init().then { v in
        v.backgroundColor = .white
        v.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        v.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.identifier)
    }

    override func setup() {
        super.setup()
        
        searchField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(searchField)
        view.addSubview(tableView)
    }
    
    override func bindConstraints() {
        super.bindConstraints()
        
        searchField.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
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

// MARK: - API
extension ViewController {
    
//    func requestGet(url: URL, callback: ((Data) -> Void)?) {
//        let session = URLSession(configuration: .default)
//        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
//            guard let data else {
//                print("get data empty")
//                return
//            }
//
//            callback?(data)
//        }
//
//        dataTask.resume()
//    }
    
    private func search(with text: String, limit: Int = 20, callback: (([Track]) -> Void)?) {
        func reformatText(_ text: String) -> String {
            return text.replacing("+", with: " ")
        }
        
        func makeURLString(parameter: [String:String]) -> String {
            var url: String = "https://itunes.apple.com/search"
            url += parameter.count > 0 ? "?" : ""
            
            for (idx, key) in parameter.keys.enumerated() {
                if let value = parameter[key] {
                    url += "\(idx == 0 ? "" : "&")\(key)=\(value)"
                }
            }
            
            print("\(#function) = \(url)")
            
            return url
        }
        
        if let tracks = cache[text],
           tracks.count == limit {
            print("이미 불러왔던 데이터입니다.")
            callback?(tracks)
            return
        }
        
        let parameter: [String: String] = [
//            "media" : "music",
            "country" : "KR",
            "limit" : String(limit),
            "term" : reformatText(text)
        ]
        print("parameter = \(parameter)")
        
        guard let url = URL(string: makeURLString(parameter: parameter)) else { return }
        let session = URLSession(configuration: .default)
        let dataTask: Void = session.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let self else { return }
            guard let data else {
                print("get data empty")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("받은 데이터: \(jsonString)")
            }
            
            do {
                // TODO: - queue?
                let decoder = JSONDecoder()
                let itunesSearchResult = try decoder.decode(iTunesSearchResult.self, from: data)
                if itunesSearchResult.resultCount == 0 {
                    // TODO: - toast (개선)
                    print("검색 결과가 없습니다.")
                }
                self.cache[text] = itunesSearchResult.results
                callback?(itunesSearchResult.results)
            } catch(let e) {
                print(e)
            }
        }.resume()
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
        
        // TODO: filtering 한국어 처리
        currentRecentSearchList = output.isEmpty ? recentSearchList : recentSearchList.filter { return $0.contains(output) }
        tableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            // TODO: - 검색어를 입력해주세요 토스트 (개선)
            return true
        }
        isFocusOnSearchField = false
        searchField.resignFirstResponder()
        
        if let textIndex = recentSearchList.firstIndex(of: text) {
            recentSearchList.remove(at: textIndex)
        }
        recentSearchList.insert(text, at: 0)
        search(with: text) { [weak self] tracks in
            guard let self else { return }
            self.trackList = tracks
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isFocusOnSearchField = true
        return true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFocusOnSearchField ? currentRecentSearchList.count : trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFocusOnSearchField {
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier) as? RecentSearchTableViewCell {
                cell.setTitle(currentRecentSearchList[indexPath.row])
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier) as? TrackTableViewCell {
                cell.setTrack(trackList[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFocusOnSearchField {
            isFocusOnSearchField = false
            tableView.deselectRow(at: indexPath, animated: true)
            
            let text = currentRecentSearchList[indexPath.row]
            searchField.text = text
            searchField.resignFirstResponder()
            search(with: text) { [weak self] tracks in
                guard let self else { return }
                self.trackList = tracks
            }
        }
    }
}
