//
//  NetworkService.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case unknowError
}

class NetworkService {
    func getMovies(page: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/movie/top_rated") else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "api_key", value: Constants.apiKey),
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error!))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.unknowError))
            }
        }
        .resume()
    }
}
