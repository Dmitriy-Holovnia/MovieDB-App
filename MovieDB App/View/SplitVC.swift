//
//  ViewController.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import UIKit

final class SplitVC: UISplitViewController {
    
    private let masterVC = UINavigationController(rootViewController: MasterVC())
    private let detailVC = UINavigationController(rootViewController: DetailVC())
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        viewControllers = [masterVC, detailVC]
        preferredDisplayMode = .oneBesideSecondary
        delegate = self
    }
}
 
//MARK: UISplitViewControllerDelegate
extension SplitVC: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
