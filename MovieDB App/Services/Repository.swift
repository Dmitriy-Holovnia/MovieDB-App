//
//  Repository.swift
//  MovieDB App
//
//  Created by Dmitiy Golovnia on 29.07.2021.
//

import Foundation
import CoreData
import SystemConfiguration

//MARK: CoreData
protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}

class CoreDataContextProvider {
    
    private let modelName: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Erorr to load persistent store: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
          } catch {
            print("Erorr to save data: \(error.localizedDescription)")
          }
    }
    
    func addMovie(movie: Movie) {
        let newMovie = MOMovie(context: viewContext)
        newMovie.id = Int64(movie.id)
        newMovie.adult = movie.adult ?? false
        newMovie.title = movie.title
        newMovie.overview = movie.overview
        newMovie.posterPath = movie.posterPath
        newMovie.releaseDate = movie.releaseDate
        
        saveContext()
    }
    
    func addMovies(movies: [Movie]) {
        movies.forEach({ addMovie(movie: $0) })
    }
    
    func getAllMovies(completion: @escaping (Result<[MOMovie], Error>) -> Void) {
        let request = NSFetchRequest<MOMovie>(entityName: "MOMovie")
        
        do {
            let movies = try viewContext.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(error))
        }
    }
}
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
    private let database = CoreDataContextProvider(modelName: "DataModel")
    
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
