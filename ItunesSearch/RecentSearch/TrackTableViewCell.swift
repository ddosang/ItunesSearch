//
//  TrackTableViewCell.swift
//  ItunesSearch
//
//  Created by 임은지 on 12/7/25.
//

import UIKit

class TrackTableViewCell: BaseTableViewCell {
    // ■ 앱 아이콘 ■ 타이틀 ■ 별점 (숫자를 포함하는 별모양 표시) ■ 스크린샷
    
    private let titleView: UIView = .init()
    
    private let iconImageView: UIImageView = .init().then { v in
        v.layer.cornerRadius = 15
        v.image = UIImage(named: "imagePlaceHolder")
    }
    
    private let titleLabel: UILabel = .init().then { v in
        v.textColor = .black
        v.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
    }
    
    // TODO: - 별점 뷰 만들기
    private let starView: UILabel = .init().then { v in
        v.textColor = .black
        v.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    func setTrack(_ track: Track) {
        print("imageURL: \(track.artworkUrl30), title: \(track.trackName), star: \(track.artistName)")
        
        // TODO: - image caching
        iconImageView.load(urlString: track.artworkUrl100 ?? track.artworkUrl60 ?? track.artworkUrl30 ?? "" )
        titleLabel.text = track.trackName
        starView.text = track.artistName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = UIImage(named: "imagePlaceHolder")
        titleLabel.text = nil
        starView.text = nil
    }
    
    override func setup() {
        titleView.addSubview(iconImageView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(starView)
        contentView.addSubview(titleView)
    }
    
    override func bindConstraints() {
        titleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
        }
        
        starView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}
