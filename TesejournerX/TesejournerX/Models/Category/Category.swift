//
//  Category.swift
//  TesejournerX
//
//  Created by Andrii Momot on 24.03.2024.
//

import Foundation

struct Category: Codable, Equatable, Hashable {
    var id: String = UUID().uuidString
    var image: String
    var name: String
    var isPersonal = false
}
