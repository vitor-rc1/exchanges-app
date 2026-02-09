//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
import DependencyInjectionInterfaces
import Detail
import DetailInterfaces
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

        injector.register(DetailCoordinating.self) { (_, arg: (UINavigationController, Coordinator?, Exchange)) in
            let (navigationController, parentCoordinator, exchange) = arg

            return DetailCoordinator(parentCoordinator: parentCoordinator,
                                     navigationController: navigationController,
                                     exchange: exchange)
        }

        injector.register(DetailCoordinating.self) { (_, arg: (UINavigationController, Coordinator?, Int)) in
            let (navigationController, parentCoordinator, exchangeId) = arg

            return DetailCoordinator(parentCoordinator: parentCoordinator,
                                     navigationController: navigationController,
                                     exchangeId: exchangeId)
        }
    }
}
