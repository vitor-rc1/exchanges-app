//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import HomeInterfaces
import NavigationInterfaces
import UIKit

public final class HomeCoordinatingSpy: HomeCoordinating {
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
