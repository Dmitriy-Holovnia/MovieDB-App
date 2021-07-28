//
//  ProductionCompany.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import Foundation

struct ProductionCompany: Codable, Hashable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
