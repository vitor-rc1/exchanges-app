//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import HomeInterfaces
import Foundation

@MainActor
protocol HomeViewModelProtocol: AnyObject {
    var delegate: HomeViewModelDelegate? { get set }
    var state: HomeViewState { get }
    var numberOfItems: Int { get }

    func loadData()
    func item(at index: Int) -> Exchange
    func didSelectRow(at index: Int)
    func formatPrice(_ value: Double) -> String
    func formatDate(_ date: String) -> String
}
