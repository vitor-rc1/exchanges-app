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

    }
}
