//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import UIKit

public final class NavigationControllerSpy: UINavigationController {
    public enum Method: Equatable {
        case pushViewController
        case present
    }

    public private(set) var calledMethods: [Method] = []

    public var pushViewControllerPassed: UIViewController?
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        calledMethods.append(.pushViewController)
        self.pushViewControllerPassed = viewController
    }

    public var presentViewControllerPassed: UIViewController?
    public override func present(_ viewControllerToPresent: UIViewController,
                                 animated flag: Bool,
                                 completion: (() -> Void)? = nil) {
        calledMethods.append(.present)
        self.presentViewControllerPassed = viewControllerToPresent
    }
}
