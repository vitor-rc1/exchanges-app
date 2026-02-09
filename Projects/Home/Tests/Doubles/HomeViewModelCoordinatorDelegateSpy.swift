//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
@testable import Home

@MainActor
final class HomeViewModelCoordinatorDelegateSpy: HomeViewModelCoordinatorDelegate {
    enum Method: Equatable {
        case navigateToDetails(Exchange)
    }

    var calledMethods: [Method] = []

    func navigateToDetails(of exchange: Exchange) {
        calledMethods.append(.navigateToDetails(exchange))
    }
}
