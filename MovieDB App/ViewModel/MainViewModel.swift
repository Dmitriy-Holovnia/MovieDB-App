//
//  MainViewModel.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import Foundation

enum ViewModelState {
    case initial, updating, success, failure(Error)
}

protocol MainViewModelProtocol {
    var currentPage: Int { get set }
    var movies: [Movie] { get set }
    var update: ((ViewModelState) -> Void)? { get set }
    var isLoading: Bool { get }
    
    func fetchWebMovies()
    func fetchLocalMovies()
}

final class MainViewModel: MainViewModelProtocol {
    
    var currentPage: Int = 1
    var movies: [Movie] = []
    var isLoading: Bool  = false
    
    var update: ((ViewModelState) -> Void)?
    
    private let repository = MovieRepository()
    
    func fetchWebMovies() {
        if isLoading { return }
        isLoading.toggle()
        update?(.updating)
        print(#function)
        repository.getAll(page: currentPage, type: .remote) { result in
            switch result {
            case .success(let movies):
                if self.currentPage == 1 { self.movies.removeAll() }
                self.movies += movies
                self.isLoading = false
                self.currentPage += 1
                self.update?(.success)
            case .failure(let error):
                self.isLoading = false
                self.update?(.failure(error))
            }
        }
    }
    
    func fetchLocalMovies() {
        update?(.updating)
        print(#function)
        repository.getAll(type: .local) { [unowned self] result in
            switch result {
            case .success(let movies):
                self.movies = movies
                movies.forEach({ print("id: \($0.id)")})
                self.update?(.success)
            case .failure(let error):
                self.update?(.failure(error))
            }
        }
    }
    
    
}
