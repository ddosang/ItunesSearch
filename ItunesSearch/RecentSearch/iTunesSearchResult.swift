//
//  Music.swift
//  ItunesSearch
//
//  Created by 임은지 on 12/6/25.
//

import Foundation

// MARK: - iTunes Search Response
struct iTunesSearchResult: Codable {
    let resultCount: Int
    let results: [Track]
}

// MARK: - Track
struct Track: Codable {
    let wrapperType: String
    let kind: String?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    
    let artworkUrl30: String?
    
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
   
    let artworkUrl60: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
}

// MARK: - Usage Example
extension Track {
    /// 트랙 재생 시간을 분:초 형식으로 반환
    var formattedDuration: String? {
        guard let trackTimeMillis else { return nil }
        let totalSeconds = trackTimeMillis / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// 아트워크 URL을 원하는 크기로 변환
    func artworkUrl(size: Int) -> String? {
        guard let artworkUrl100 else { return nil }
        return artworkUrl100.replacingOccurrences(of: "100x100bb", with: "\(size)x\(size)bb")
    }
}
