//
//  NetworkService.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func getMovieDetail(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/550?api_key=89878b56d6dce7c55d0958f65ac39598") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error!))
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(Movie.self, from: data)
                    completion(.success(movie))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    func getMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void ) {
        guard var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/movie/top_rated") else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "api_key", value: "89878b56d6dce7c55d0958f65ac39598"),
        ]
        
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error!))
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MovieResponse.self, from: data)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}
