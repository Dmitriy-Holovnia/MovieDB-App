//
//  MovieCollectionViewCell.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = String(describing: MovieCollectionViewCell.self)
    
    private let cache: NSCache = NSCache<NSString, NSData>()
    private var task: URLSessionDataTask!
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task.cancel()
        movieImageView.image = nil
//        NSCache.object(<#T##self: NSCache<_, _>##NSCache<_, _>#>)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure UI
    func configureCell(with movie: Movie) {
        guard let posterPath = movie.posterPath,
              let url = URL(string: "https://www.themoviedb.org/t/p/w500/\(posterPath)")
        else { return }
        
        if let image = getCachedImage(url: url) {
            movieImageView.image = image
            return
        }
        task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, error in
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
        })
        task.resume()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(movieImageView)
        
        movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
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

