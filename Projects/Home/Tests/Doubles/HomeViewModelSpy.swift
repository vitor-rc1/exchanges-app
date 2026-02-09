//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces

@testable import Home

@MainActor
final class HomeViewModelSpy: HomeViewModelProtocol {
    enum Method: Equatable {
        case loadData
        case item
        case didSelectRow
    }

    var calledMethods: [Method] = []
    var delegate: HomeViewModelDelegate?
    var numberOfItems: Int = 0
    var itemsToReturn: [Exchange] = []

    func loadData() {
        calledMethods.append(.loadData)
    }

    func item(at index: Int) -> Exchange {
        calledMethods.append(.item)
        return itemsToReturn[index]
    }

    func didSelectRow(at index: Int) {
        calledMethods.append(.didSelectRow)
    }
}
