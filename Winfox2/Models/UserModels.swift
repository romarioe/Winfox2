//
//  UserModels.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import Foundation

struct UserModel: Codable{
    let firstname: String
    let lastname: String
    let email: String
    let password: String
    let id: String
}



struct AuthModel: Codable{
    let email: String
    let password: String
    let id: String
}


struct UpdateUserModel: Codable{
    let email: String
    let firstname: String
    let lastname: String
    let birthdate: String
    let preferences: [String]
    let organization: String
    let position: String
    let birthPlace: String
    let middlename: String
    let id: String
}
