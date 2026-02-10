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
final class DetailViewModelCoordinatorDelegateSpy: DetailViewModelCoordinatorDelegate {
    enum Method: Equatable {
        case didRequestOpenURL(URL)
    }

    var calledMethods: [Method] = []

    func didRequestOpenURL(_ url: URL) {
        calledMethods.append(.didRequestOpenURL(url))
    }
}
