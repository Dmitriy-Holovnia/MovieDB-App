//
//  MovieResponce.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
}
