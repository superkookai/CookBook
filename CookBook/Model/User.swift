//
//  User.swift
//  CookBook
//
//  Created by Weerawut Chaiyasomboon on 16/03/2568.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let username: String
    let email: String
}
