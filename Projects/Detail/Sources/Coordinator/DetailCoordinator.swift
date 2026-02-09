import UIKit
import DetailInterfaces
import DependencyInjectionInterfaces
import HomeInterfaces
import NavigationInterfaces
import NetworkingInterfaces

@MainActor
public final class DetailCoordinator: DetailCoordinating {
    // MARK: - Properties

    public weak var parentCoordinator: Coordinator?
    public var children: [Coordinator] = []
    public var navigationController: UINavigationController

    private var exchange: Exchange?
    private var exchangeId: Int?

    // MARK: - Initialization

    public init(parentCoordinator: Coordinator?,
                navigationController: UINavigationController,
                exchange: Exchange) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.exchange = exchange
    }

    public init(parentCoordinator: Coordinator?,
                navigationController: UINavigationController,
                exchangeId: Int) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.exchangeId = exchangeId
    }

    // MARK: - DetailCoordinating

    public func start() {
        let resolver = SharedContainer.shared.resolver()
        let networkService: NetworkServiceProtocol = resolver.resolve()
        let detailService = DetailService(networkService: networkService)
        let viewModel = DetailViewModel(service: detailService)
        if let exchange {
            viewModel.configure(with: exchange)
        }
        if let exchangeId {
            viewModel.configure(with: exchangeId)
        }

        viewModel.coordinatorDelegate = self
        let viewController = DetailViewController(viewModel: viewModel)

        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - DetailViewModelCoordinatorDelegate

extension DetailCoordinator: DetailViewModelCoordinatorDelegate {
    public func didRequestOpenURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
