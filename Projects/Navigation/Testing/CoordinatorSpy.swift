//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import NavigationInterfaces
import UIKit

final class CoordinatorSpy: Coordinator {
    public enum Method {
        case start
    }

    public var calledMethods: [Method] = []
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    public init(parentCoordinator: Coordinator? = nil,
                children: [Coordinator],
                navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.children = children
        self.navigationController = navigationController
    }

    func start() {
        calledMethods.append(.start)
    }
}
