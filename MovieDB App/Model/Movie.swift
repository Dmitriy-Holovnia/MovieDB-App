//
//  Movie.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import Foundation

struct Movie: Codable, Hashable {
    let id: Int
    let title: String?
    let voteAverage: Double?
    let adult: Bool?
    let posterPath: String?
    let overview: String?
    let releaseDate: String?
    
    init(id: Int, title: String?, voteAverage: Double?, adult: Bool?, posterPath: String?, overview: String?, releaseDate: String?) {
        self.id = id
        self.title = title
        self.voteAverage = voteAverage
        self.adult = adult
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
    }
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case id, title, adult, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
