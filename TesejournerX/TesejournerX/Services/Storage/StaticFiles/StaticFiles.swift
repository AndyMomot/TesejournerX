//
//  StaticFiles.swift
//  TesejournerX
//
//  Created by Andrii Momot on 22.03.2024.
//

import Foundation

enum StaticFiles {
    enum Links {
        static let offerta = "https://tesejournerx.info"
        static let support = "https://support.tesejournerx.info"
    }
    
    enum Categories {
        static let all: [Category] = [
            jedzenie, szkolenie, joga, siłownia, odzież, zdrowie, inne, dodaj
        ]
        static let jedzenie = Category(image: Asset.foodCategory.name, name: "Jedzenie")
        static let szkolenie = Category(image: Asset.educationCategory.name, name: "Szkolenie")
        static let joga = Category(image: Asset.yogaCategory.name, name: "Joga")
        static let siłownia = Category(image: Asset.sportCategory.name, name: "Siłownia")
        static let odzież = Category(image: Asset.clothersCategory.name, name: "Odzież")
        static let zdrowie = Category(image: Asset.healthCatecory.name, name: "Zdrowie")
        static let inne = Category(image: "", name: "Inne")
        static let dodaj = Category(image: "", name: "Dodaj")
    }
}
