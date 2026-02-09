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
import NetworkingInterfaces
import UIKit

public final class HomeCoordinator: HomeCoordinating {
    public var parentCoordinator: (Coordinator)?
    public var children: [Coordinator] = []
    public var navigationController: UINavigationController

    public init(parentCoordinator: Coordinator? = nil,
                navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }

    public func start() {
        let resolver = SharedContainer.shared.resolver()
        let networkService: NetworkServiceProtocol = resolver.resolve()
        let service = HomeService(networkService: networkService)
        let viewModel = HomeViewModel(service: service)
        viewModel.coordinatorDelegate = self
        let homeVC = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(homeVC, animated: false)
    }
}

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func navigateToDetails(of exchange: Exchange) {}
}
