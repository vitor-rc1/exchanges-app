//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import HomeInterfaces
import Foundation

protocol HomeServiceProtocol: AnyObject, Sendable {
    @concurrent
    func fetchExchangesList(page: Int, limit: Int) async throws(ServiceError) -> [ExchangeSummary]
    @concurrent
    func fetchDetailsFor(ids: [String]) async throws(ServiceError) -> [ExchangeDetail]
}
