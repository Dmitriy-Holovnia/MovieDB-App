//
//  MainViewModel.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import Foundation

enum ViewModelState: Equatable {
    case initial, updating, success, failure(Error)
    
    static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.updating, .updating):
            return true
        default:
            return false
        }
    }
}

protocol MainViewModelProtocol {
    var currentPage: Int { get set }
    var movies: [Movie] { get set }
    var update: ((ViewModelState) -> Void)? { get set }
    var currentState: ViewModelState { get }
    
    func fetchMovies()
}

final class MainViewModel: MainViewModelProtocol {
    
    var currentPage: Int = 1
    var movies: [Movie] = []
    var currentState: ViewModelState = .initial
    
    var update: ((ViewModelState) -> Void)?
    
    func fetchMovies() {
        if currentState == .updating { return }
        currentState = .updating
        update?(.updating)
        
        NetworkService.shared.getMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let reponse):
                self.movies += reponse.results
                self.currentPage += 1
                self.currentState = .success
                DispatchQueue.main.async {
                    self.update?(.success)
                }
            case .failure(let error):
                self.update?(.failure(error))
                self.currentState = .failure(error)
            }
        }
    }
    
    
}
