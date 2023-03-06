//
//  UserData.swift
//  Albums
//
//  Created by Ziad Alfakharany on 05/03/2023.
//

import Foundation

struct UserData: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: address
    struct address: Codable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
    }
    let phone: String
}




