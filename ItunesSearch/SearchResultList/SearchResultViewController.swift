//
//  SearchResultViewController.swift
//  ItunesSearch
//
//  Created by 임은지 on 12/6/25.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
    var trackList: [Track] = []
    
    init(text: String) {
        super.init(nibName: nil, bundle: nil)
        search(with: text) { [weak self] tracks in
            guard let self else { return }
            self.trackList = tracks
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


// MARK: - API
extension SearchResultViewController {
    
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
    
    private func search(with text: String, callback: (([Track]) -> Void)?) {
        func reformatText(_ text: String) -> String {
            return text.replacing("+", with: " ")
        }
        
        func makeURLString(parameter: [String:String]) -> String {
            var url: String = "https://itunes.apple.com/search"
            url += parameter.count > 0 ? "?" : ""
            
            for (idx, key) in parameter.keys.enumerated() {
                if let value = parameter[key] {
                    url += "\(idx == 0 ? "" : "&")\(key):\(value)"
                }
            }
            
            print("\(#function) = \(url)")
            
            return url
        }
        
        let parameter: [String: String] = [
//            "media" : "music",
            "country" : "KR",
            "limit" : "200",
            "term" : reformatText(text)
        ]
        print("parameter = \(parameter)")
        
        guard let url = URL(string: makeURLString(parameter: parameter)) else { return }
        let session = URLSession(configuration: .default)
        let dataTask: Void = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data else {
                print("get data empty")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let itunesSearchResult = try decoder.decode(iTunesSearchResult.self, from: data)
                callback?(itunesSearchResult.results)
            } catch(let e) {
                print(e)
            }
        }.resume()
        
    }
    
    
}
