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
final class HomeViewModelDelegateSpy: HomeViewModelDelegate {
    enum Method: Equatable {
        case didUpdateState(HomeViewState)
    }

    var calledMethods: [Method] = []

    func didUpdateState(_ state: HomeViewState) {
        calledMethods.append(.didUpdateState(state))
    }
}
