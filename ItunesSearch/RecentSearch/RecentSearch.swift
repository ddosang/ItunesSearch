//
//  RecentSearchList.swift
//  ItunesSearch
//
//  Created by 임은지 on 12/7/25.
//

import Foundation

struct RecentSearch {
    static let recentSearchList = RecentSearch()
    
    private let key = "recentSearches"
    private let limit = 20   // 최근 검색어 최대 개수
    
    func load() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    
    func add(_ keyword: String) {
        var list = load()
        
        // 이미 존재하면 삭제 후 맨 앞으로
        list.removeAll { $0 == keyword }
        list.insert(keyword, at: 0)
        
        // 최대 개수 제한
        if list.count > limit {
            list.removeLast()
        }
        
        UserDefaults.standard.set(list, forKey: key)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
