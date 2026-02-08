//
//  SceneDelegate.swift
//  ExchangesApp
//
//  Created by Vitor Conceicao on 06/02/26.
//

import UIKit
import DependencyInjectionInterfaces

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinating?

    #if DEBUG
    var isTesting: Bool {
        return ProcessInfo.processInfo.environment["IS_TESTING"] == "true"
    }
    #endif

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        #if DEBUG
        if isTesting { return }
        #endif

        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController()
        let resolver = SharedContainer.shared.resolver()

        appCoordinator = resolver.resolve(AppCoordinating.self, argument: nav)
        appCoordinator?.start()

        window.rootViewController = nav
        window.makeKeyAndVisible()

        self.window = window
    }
}
