//
//  MovieResponse.swift
//  MovieDB App
//
//  Created by Dmitiy Golovnia on 30.07.2021.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
}
