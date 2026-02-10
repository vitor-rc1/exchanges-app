import UIKit
import DetailInterfaces
import NavigationInterfaces

@MainActor
public final class DetailCoordinatingSpy: DetailCoordinating {
    public enum Method: Equatable {
        case start
    }

    public var calledMethods: [Method] = []
    public var parentCoordinator: Coordinator?
    public var children: [Coordinator] = []
    public var navigationController: UINavigationController

    public init(parentCoordinator: Coordinator? = nil,
                children: [Coordinator],
                navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.children = children
        self.navigationController = navigationController
    }

    public func start() {
        calledMethods.append(.start)
    }
}
