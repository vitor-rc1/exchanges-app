//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

@MainActor
protocol DetailViewModelProtocol: AnyObject {
    var assets: [Asset] { get }
    var delegate: DetailViewModelDelegate? { get set }
    var state: DetailViewState { get }

    func loadData()
    func didTapRetry()
    func didTapWebsite()
    func didTapTwitter()
}
