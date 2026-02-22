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
    func fetchExchangesList(page: Int, limit: Int) async throws(ServiceError) -> [ExchangeSummary]
    func fetchDetailsFor(ids: [String]) async throws(ServiceError) -> [ExchangeDetail]
}
