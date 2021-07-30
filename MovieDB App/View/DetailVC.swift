//
//  DetailVC.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 30.07.2021.
//

import UIKit

final class DetailVC: UIViewController {
    
    var movie: Movie?
    private let cache: NSCache = NSCache<NSString, NSData>()
    
    //MARK: UI Elements
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ageLimitImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "18.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .red
        return imageView
    }()
    
    private lazy var overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Overview"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var releaseTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Release date:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var releaseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ratingView.animate()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        if let splitViewController = splitViewController {
            if let navigationController = splitViewController.viewControllers.last as? UINavigationController {
                navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
                navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    private func configureUI() {
        title = movie?.title ?? "Movie detail"
        ageLimitImageView.isHidden = !(movie?.adult ?? true)
        overviewLabel.text = movie?.overview
        releaseLabel.text = movie?.releaseDate
        ratingView.rating = movie?.voteAverage ?? 0
        downloadImage(urlString: movie?.posterPath)
        
        view.addSubview(movieImageView)
        view.addSubview(ageLimitImageView)
        view.addSubview(overviewTitleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(releaseTitleLabel)
        view.addSubview(releaseLabel)
        view.addSubview(ratingView)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.4),
            
            ageLimitImageView.widthAnchor.constraint(equalToConstant: 30),
            ageLimitImageView.heightAnchor.constraint(equalToConstant: 30),
            ageLimitImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            ageLimitImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            overviewTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            overviewTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 6),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            releaseTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            releaseTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            
            releaseLabel.topAnchor.constraint(equalTo: releaseTitleLabel.bottomAnchor, constant: 10),
            releaseLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            
            ratingView.heightAnchor.constraint(equalToConstant: 40),
            ratingView.widthAnchor.constraint(equalToConstant: 40),
            ratingView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            ratingView.topAnchor.constraint(equalTo: releaseLabel.bottomAnchor, constant: 10),
        ])
    }
    
    //FIXME: remove to network service
    func downloadImage(urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: "https://www.themoviedb.org/t/p/w500/\(urlString)")
        else { return }
        
        if let image = getCachedImage(url: url) {
            movieImageView.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, error in
            guard let self = self else { return }
            if error != nil {
                print("Image error: \(error!.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.movieImageView.image = UIImage(data: data)
                }
                self.saveImageToCache(data: data, url: url)
            }
        }).resume()
        
    }
    
    //MARK: Helpers
    private func saveImageToCache(data: Data, url: URL) {
        cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
    }
    
    private func getCachedImage(url: URL) -> UIImage? {
        if let data = cache.object(forKey: url.absoluteString as NSString) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
