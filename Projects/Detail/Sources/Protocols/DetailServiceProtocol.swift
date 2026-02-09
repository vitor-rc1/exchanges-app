//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

protocol DetailServiceProtocol: AnyObject, Sendable {
    func fetchExchangeAssets(id: Int) async throws -> [Asset]
}
