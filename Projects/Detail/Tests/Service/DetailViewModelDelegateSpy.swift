//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
@testable import Detail

@MainActor
final class DetailViewModelDelegateSpy: DetailViewModelDelegate {
    enum Method: Equatable {
        case didUpdateState(DetailViewState)
    }

    var calledMethods: [Method] = []

    func didUpdateState(_ state: DetailViewState) {
        calledMethods.append(.didUpdateState(state))
    }
}
