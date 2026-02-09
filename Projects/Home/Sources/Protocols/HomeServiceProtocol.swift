//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

protocol HomeServiceProtocol: AnyObject, Sendable {
    func fetchExchangesList(page: Int, limit: Int) async throws -> [ExchangeSummary]
    func fetchDetailsFor(ids: [String]) async throws -> [ExchangeDetail]
}
