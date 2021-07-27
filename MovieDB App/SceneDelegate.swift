//
//  SceneDelegate.swift
//  MovieDB App
//
//  Created by Dima Golovnya on 27.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplitVC()
        window?.makeKeyAndVisible()
    }

}

