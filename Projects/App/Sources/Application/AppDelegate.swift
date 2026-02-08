//
//  AppDelegate.swift
//  ExchangesApp
//
//  Created by Vitor Conceicao on 06/02/26.
//

import DependencyInjection
import DependencyInjectionInterfaces
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    override init() {
        super.init()
        setupDependencies()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    @MainActor
    private func setupDependencies() {
        let injector = Injector()
        SharedContainer.shared.setInjector(injector)
    }
}
