//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

@MainActor
protocol HomeViewModelDelegate: AnyObject {
    func didUpdateState(_ state: HomeViewState)
}
