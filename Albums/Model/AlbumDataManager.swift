//
//  AlbumDataManager.swift
//  Albums
//
//  Created by Ziad Alfakharany on 05/03/2023.
//

import Foundation

protocol AlbumDataManagerDelegate {
    func didGetUser(_ albumDataManager: AlbumDataManager, data: UserDataModel)
    func didGetAlbums(_ albumDataManager: AlbumDataManager, data: [AlbumDataModel])
    func didFailWithError(error: Error)
}

protocol PhotoDataManagerDelegate {
    func didGetPhotos(_ albumDataManager: AlbumDataManager, data: [PicModel])
    func didFailWithError(error: Error)
}

struct AlbumDataManager {
    let url = "https://jsonplaceholder.typicode.com/api/GET/"
    var delegate: AlbumDataManagerDelegate?
    var PicDelegate: PhotoDataManagerDelegate?
    
    func getUsers() {
        let urlString = "\(url)users"
        performRequest(with: urlString, type: "user")
    }
    
    func getAlbums(user: UserDataModel) {
        let urlString = "\(url)albums?userId=\(user.id)"
        performRequest(with: urlString, type: "albums")
    }
    
    func getPhotos(albumID: Int) {
        let urlString = "\(url)photos?albumId=\(albumID)"
        performRequest(with: urlString, type: "photos")
    }
    
    
    func performRequest(with urlString: String, type: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    self.PicDelegate?.didFailWithError(error: error!)
                    return
                }
                if type == "user" {
                    if let safeData = data {
                        if let data = self.parseUser(safeData) {
                            getAlbums(user: data)
                            self.delegate?.didGetUser(self, data: data)
                        }
                    }
                } else if type == "albums" {
                    if let safeData = data {
                        if let data = self.parseAlbums(safeData) {
                            self.delegate?.didGetAlbums(self, data: data)
                        }
                    }
                } else if type == "photos"{
                    if let safeData = data {
                        if let data = self.parsePhotos(safeData) {
                            self.PicDelegate?.didGetPhotos(self, data: data)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseUser(_ userDataModel: Data) -> UserDataModel? {
        let decoder = JSONDecoder()
        var userDataArr = [UserDataModel]()
        do {
            let decodedData = try decoder.decode([UserData].self, from: userDataModel)
            
            for i in 0...9 {
                let id = decodedData[i].id
                let name = decodedData[i].name
                let street = decodedData[i].address.street
                let suite = decodedData[i].address.suite
                let city = decodedData[i].address.city
                let zipCode = decodedData[i].address.zipcode
                let phone = decodedData[i].phone
                
                let user = UserDataModel(id: id, name: name, street: street, suite: suite, city: city, zipcode: zipCode, phone: phone)
                userDataArr.append(user)
            }
            
            let returnUser = userDataArr.randomElement()
            return returnUser
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseAlbums(_ albumDataModel: Data) -> [AlbumDataModel]? {
        let decoder = JSONDecoder()
        var albumArr = [AlbumDataModel]()
        do {
            let decodedData = try decoder.decode([AlbumDataModel].self, from: albumDataModel)
            
            for i in 0...9 {
                let id = decodedData[i].id
                let title = decodedData[i].title
                
                let album = AlbumDataModel(id: id, title: title)
                albumArr.append(album)
            }
            return albumArr
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parsePhotos(_ picModel: Data) -> [PicModel]? {
        let decoder = JSONDecoder()
        var picArr = [PicModel]()
        do {
            let decodedData = try decoder.decode([PicModel].self, from: picModel)
            
            for i in 0...49 {
                let title = decodedData[i].title
                let url = decodedData[i].url
                
                let photo = PicModel(title: title, url: url)
                picArr.append(photo)
            }
            return picArr
        } catch {
            PicDelegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
