//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

@MainActor
protocol DetailViewModelCoordinatorDelegate: AnyObject {
    func didRequestOpenURL(_ url: URL)
}
