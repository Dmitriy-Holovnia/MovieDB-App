//
//  Repository.swift
//  MovieDB App
//
//  Created by Dmitiy Golovnia on 29.07.2021.
//

import UIKit
import CoreData
import SystemConfiguration

//MARK: Repository
enum RepositoryType {
    case local, remote
}

protocol Repository {
    associatedtype T
    
    func get(id: Int, type: RepositoryType, completion: @escaping (Result<T, Error>) -> Void)
    func getAll(page: Int, type: RepositoryType, completion: @escaping (Result<[T], Error>) -> Void)
}

struct MovieRepository: Repository {
    typealias T = Movie
    
    private let networkService = NetworkService()
    private let database = CoreDataService()
    
    func get(id: Int, type: RepositoryType, completion: @escaping (Result<Movie, Error>) -> Void) {
        print(#function)
    }
    
    func getAll(page: Int = 1, type: RepositoryType, completion: @escaping (Result<[Movie], Error>) -> Void) {
        switch type {
        case .local:
            database.getAllMovies { result in
                switch result {
                case .success(let data):
                    let movies = data.map({ $0.toDomainModel() })
                    completion(.success(movies))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .remote:
            networkService.getMovies(page: page) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(MovieResponse.self, from: data)
                        let movies = response.results
                        database.addMovies(movies: movies)
                        DispatchQueue.main.async {
                            completion(.success(movies))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
