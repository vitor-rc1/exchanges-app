//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
import DependencyInjectionInterfaces
import NetworkingInterfaces
import Networking

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
    }
}
