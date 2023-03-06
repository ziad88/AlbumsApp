//
//  PicCollectionViewFlowLayout.swift
//  Albums
//
//  Created by Ziad Alfakharany on 06/03/2023.
//

import UIKit

class PicCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
            super.prepare()

            guard let collectionView = collectionView else { return assertionFailure("Collection view not found") }

            let availableWidth = collectionView.bounds.width
            let availableHeight = collectionView.bounds.height
            let itemWidth: CGFloat = (availableWidth/3).rounded(.down)
            let itemHeight: CGFloat = (availableHeight/6).rounded(.down)
            itemSize = CGSize(width: itemWidth, height: itemHeight)

        sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = .zero
        minimumInteritemSpacing = .zero
        }
}
