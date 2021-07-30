//
//  CoreDataService.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 30.07.2021.
//

import UIKit
import CoreData

protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}

final class CoreDataService {
    
    private let persistentContainer: NSPersistentContainer!
    
    init() {
        self.persistentContainer = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)!.persistentContainer
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
    }
    
    func addMovies(movies: [Movie]) {
        movies.forEach({ addMovie(movie: $0) })
    }
    
    func getAllMovies(completion: @escaping (Result<[MOMovie], Error>) -> Void) {
        let request = NSFetchRequest<MOMovie>(entityName: "MOMovie")
        
        do {
            let movies = try viewContext.fetch(request)
            completion(.success(movies))
            deleteAllMovies(movies)
        } catch {
            completion(.failure(error))
        }
    }
    
    public func deleteAllMovies(_ movies: [MOMovie]) {
        movies.forEach({ viewContext.delete($0) })
        saveContext()
    }
}
