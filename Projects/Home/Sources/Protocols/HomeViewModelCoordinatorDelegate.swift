//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces

@MainActor
protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func navigateToDetails(of exchange: Exchange)
}
