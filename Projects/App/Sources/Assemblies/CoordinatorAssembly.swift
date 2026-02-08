//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
import DependencyInjectionInterfaces
import HomeInterfaces
import Home
import NavigationInterfaces

import UIKit

public struct CoordinatorAssembly {
    private let injector: DependencyInjector

    public init(injector: DependencyInjector) {
        self.injector = injector
    }

    @MainActor
    public func register() {
        injector.register(AppCoordinating.self) { (_, arg: UINavigationController) in
            AppCoordinator(navigationController: arg)
        }

        injector.register(HomeCoordinating.self) { (_, arg: (UINavigationController, Coordinator?)) in
            let (navigationController, parentCoordinator) = arg

            return HomeCoordinator(parentCoordinator: parentCoordinator,
                                   navigationController: navigationController)
        }
    }
}
