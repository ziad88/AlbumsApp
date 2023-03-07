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
    
    var selectedAlbumID: Int!
    var selectedAlbumTitle: String!
    
    var photos = [PicModel](repeating: PicModel(title: "", url: ""), count: 50)
    
    var filteredPhotos = [PicModel](repeating: PicModel(title: "", url: ""), count: 50) {
        didSet {
            picCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedAlbumTitle
        picCollectionView.delegate = self
        picCollectionView.dataSource = self
        searchBar.delegate = self
        albumDataManager.PicDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albumDataManager.getPhotos(albumID: selectedAlbumID)
        searchBar.placeholder = "Search in images.."
    }
    
    
//MARK: - --------AlbumDataManager Delegate Methods------------------------------------
    func didGetPhotos(_ albumDataManager: AlbumDataManager, data: [PicModel]) {
        DispatchQueue.main.async {
            for i in 0...49 {
                self.photos[i] = data[i]
                self.filteredPhotos[i] = data[i]
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - --------UICollectionView Delegate, DataSource Methods---------------------------
extension AlbumPicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = CollectionViewCell()
        
        if let recell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseableCell", for: indexPath) as? CollectionViewCell {
            recell.configure(with: filteredPhotos[indexPath.row].url)
            cell = recell
        }
        return cell
    }
}

//MARK: - --------UISearchBarD Delegate Method---------------------------
extension AlbumPicViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredPhotos = []
        
        if searchText == "" {
            filteredPhotos = photos
        }
        
        for i in 0...49 {
            if (photos[i].title.uppercased().contains(searchText.uppercased()))  {
                filteredPhotos.append(photos[i])
            }
        }
        picCollectionView.reloadData()
    }
}
