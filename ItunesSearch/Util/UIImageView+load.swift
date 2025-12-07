//
//  UIImage+load.swift
//  Search
//
//  Created by 임은지 on 4/1/24.
//

import UIKit

extension UIImageView {
    func load(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            } catch(let e) {
                print("\(e) error 로 \(urlString) 사진 로딩에 실패하였습니다.")
            }
        }
    }
}
