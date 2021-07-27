//
//  SpokenLanguage.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import Foundation

struct SpokenLanguage: Codable {
    let englishName, iso639, name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639 = "iso_639_1"
        case name
    }
}
