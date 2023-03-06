//
//  ViewController.swift
//  Albums
//
//  Created by Ziad Alfakharany on 05/03/2023.
//

import UIKit

class ProfileViewController: UIViewController, AlbumDataManagerDelegate {

    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileAddressLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var albumDataManager = AlbumDataManager()
    
    var albumTitles = [String](repeating: "loading", count: 10) {
        didSet {
            tableView.reloadData()
        }
    }
    
    var albumIds = [Int](repeating: 0, count: 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        albumDataManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        albumDataManager.getUsers()
    }

    func didGetUser(_ albumDataManager: AlbumDataManager, data: UserDataModel) {
        DispatchQueue.main.async {
            self.profileNameLabel.text = data.name
            self.profileAddressLabel.text = "\(data.city),\(data.street),\(data.suite),\(data.phone)"
        }
    }
    
    func didGetAlbums(_ albumDataManager: AlbumDataManager, data: [AlbumDataModel]) {
        DispatchQueue.main.async {
            for i in 0...9 {
                self.albumTitles[i] = data[i].title
                self.albumIds[i] = data[i].id
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumTitles.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        cell.textLabel?.text = self.albumTitles[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAlbum", sender: self)
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AlbumPicViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedAlbumID = albumIds[indexPath.row]
            destinationVC.selectedAlbumTitle = albumTitles[indexPath.row]
        }
    }

    
}
