//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import HomeInterfaces
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
//        let viewModel = HomeViewModel()
//        viewModel.coordinatorDelegate = self
//        let homeVC = HomeViewController(viewModel: viewModel)
//        navigationController.pushViewController(homeVC, animated: false)
    }
}
