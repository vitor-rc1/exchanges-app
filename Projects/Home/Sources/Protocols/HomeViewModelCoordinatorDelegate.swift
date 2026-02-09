//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//
    
import Foundation

@MainActor
protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func navigateToDetails(of exchange: Exchange)
}
