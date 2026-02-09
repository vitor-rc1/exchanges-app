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

    }
}
