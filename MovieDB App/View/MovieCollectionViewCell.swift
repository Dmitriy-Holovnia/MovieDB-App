//
//  MovieCollectionViewCell.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 28.07.2021.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = String(describing: MovieCollectionViewCell.self)
    
    var task: URLSessionDataTask!
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task.cancel()
        movieImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with movie: Movie) {
        guard let posterPath = movie.posterPath,
              let url = URL(string: "https://www.themoviedb.org/t/p/w500/\(posterPath)")
        else { return }
        task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, error in
            guard let self = self else { return }
            if error != nil {
                print("Image error: \(error!.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            }
        })
        task.resume()
    }
    
    func configureUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(movieImageView)
        
        movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

