//
//  AlbumPicViewController.swift
//  Albums
//
//  Created by Ziad Alfakharany on 06/03/2023.
//

import UIKit

class AlbumPicViewController: UIViewController, PhotoDataManagerDelegate {
   
    @IBOutlet weak var picCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var albumDataManager = AlbumDataManager()
    
    var selectedAlbumID: Int! {
        didSet {
            albumDataManager.getPhotos(albumID: selectedAlbumID)
        }
    }
    var selectedAlbumTitle: String!
    
//    var albumPhotos = [String](repeating: "loading", count: 50) {
//        didSet {
//            picCollectionView.reloadData()
//        }
//    }
    
    var photos = [PicModel](repeating: PicModel(title: "", url: ""), count: 50) {
        didSet {
            picCollectionView.reloadData()
        }
    }
    
    //var photosTitles = [String](repeating: "loading", count: 50)
    //var filteredTitles: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedAlbumTitle
        picCollectionView.delegate = self
        picCollectionView.dataSource = self
        searchBar.delegate = self
        albumDataManager.PDelegate = self
        albumDataManager.getPhotos(albumID: selectedAlbumID)
    }
    
    func didGetPhotos(_ albumDataManager: AlbumDataManager, data: [PicModel]) {
        DispatchQueue.main.async {
            for i in 0...49 {
//                self.albumPhotos[i] = data[i].url
//                self.photosTitles[i] = data[i].title
                self.photos[i] = data[i]
                print(self.photos[i].title)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension AlbumPicViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = CollectionViewCell()
        
        if let recell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseableCell", for: indexPath) as? CollectionViewCell {
            recell.configure(with: photos[indexPath.row].url)
            cell = recell
        }
        return cell
    }
}

extension AlbumPicViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//                if searchText != "" {
//                    photos = []
//                }
        
                for pic in photos {
                    if (pic.title.contains(searchText))  {
                        photos.insert(PicModel(title: pic.title, url: pic.url), at: 0)
                    }
                }
        
        
    }
}
