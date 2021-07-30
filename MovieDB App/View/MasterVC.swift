//
//  MasterVC.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import UIKit
import CoreData

final class MasterVC: UIViewController {
    
    private var viewModel: MainViewModelProtocol!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>!
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseId)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureDataSource()
        viewModel = MainViewModel()
        viewModel.update = updateUI
        viewModel.fetchLocalMovies()
    }
    
    //MARK: Configure UI
    private func updateUI(state: ViewModelState) {
        switch state {
        case .initial:
            print("init")
        case .updating:
            print("updating")
        case .success:
            print("success")
            applyDataSourceSnapshot()
        case .failure(let error):
            print("updating error: \(error.localizedDescription)")
        }
    }
    
    private func setup() {
        title = "All movies"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: Helpers
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Movie>(collectionView: collectionView, cellProvider: { cv, indexPath, movie in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId,
                                              for: indexPath) as! MovieCollectionViewCell
            cell.configureCell(with: movie)
            return cell
        })
    }
    
    func applyDataSourceSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.movies, toSection: 0)
        dataSource.apply(snapshot)
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension MasterVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let detailVC = DetailVC()
        detailVC.movie = movie
        let dvc = UINavigationController(rootViewController: detailVC)
        splitViewController?.showDetailViewController(dvc, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            viewModel.fetchWebMovies()
        }
    }
}
