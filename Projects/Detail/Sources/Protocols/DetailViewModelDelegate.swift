//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

@MainActor
protocol DetailViewModelDelegate: AnyObject {
    func didUpdateState(_ state: DetailViewState)
}
