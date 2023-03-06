//
//  CollectionViewCell.swift
//  Albums
//
//  Created by Ziad Alfakharany on 06/03/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with cellImageName: String) {
        imageView.downloaded(from: cellImageName)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
}

extension UIImageView {
    func downloaded(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
