//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

@MainActor
protocol HomeViewModelProtocol: AnyObject {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfItems: Int { get }

    func loadData()
    func item(at index: Int) -> Exchange
    func didSelectRow(at index: Int)
}
