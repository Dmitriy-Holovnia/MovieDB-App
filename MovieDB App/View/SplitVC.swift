//
//  ViewController.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import UIKit

final class SplitVC: UISplitViewController {
    
    let masterVC = UINavigationController(rootViewController: MasterVC())
    let detailVC = UINavigationController(rootViewController: DetailVC())
    
    //MARK: UI Elements
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        viewControllers = [masterVC, detailVC]
        preferredDisplayMode = .oneBesideSecondary
        delegate = self
    }
    
    
}

extension SplitVC: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

final class DetailVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
}
