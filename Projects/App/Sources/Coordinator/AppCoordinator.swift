//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import DependencyInjectionInterfaces
import HomeInterfaces
import NavigationInterfaces
import UIKit

protocol AppCoordinating: Coordinator {}

@MainActor
final class AppCoordinator: AppCoordinating {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let resolver = SharedContainer.shared.resolver()
        let arg: (UINavigationController, Coordinator?) = (navigationController, self)

        let homeCoordinator = resolver.resolve(HomeCoordinating.self,
                                               argument: arg)
        children.append(homeCoordinator)
        homeCoordinator.start()
    }
}
