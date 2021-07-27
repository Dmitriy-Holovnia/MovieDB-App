//
//  ProductionCountry.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import Foundation

struct ProductionCountry: Codable {
    let iso, name: String

    enum CodingKeys: String, CodingKey {
        case iso = "iso_3166_1"
        case name
    }
}
