//
//  ViewController.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import UIKit

class SplitVC: UISplitViewController {
    
    let masterVC = UINavigationController(rootViewController: MasterVC(collectionViewLayout: UICollectionViewFlowLayout()))
    let detailVC = UINavigationController(rootViewController: DetailVC())
    
    //MARK: UI Elements
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        viewControllers = [masterVC, detailVC]
        preferredDisplayMode = .allVisible
        delegate = self
    }
    
    
}

extension SplitVC: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

class MasterVC: UICollectionViewController {
    
    let colors: [UIColor] = [.red, .blue, .yellow, .purple, .systemPink]
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All movies"
        view.backgroundColor = .yellow
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular/?api_key=89878b56d6dce7c55d0958f65ac39598") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let movie = try decoder.decode([Movie].self, from: data)
                    print("Movie: \(movie)")
                } catch {
                    return
                }
            }
        }
        .resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = colors[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = color
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        let detailVC = DetailVC()
        detailVC.view.backgroundColor = color
        detailVC.title = "Movie Detail"
        let dvc = UINavigationController(rootViewController: detailVC)
        splitViewController?.showDetailViewController(dvc, sender: nil)
    }
}

extension MasterVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class DetailVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = .green
    }
}
