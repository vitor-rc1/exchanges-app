//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
@testable import Detail

@MainActor
final class DetailServiceProtocolSpy: DetailServiceProtocol, Sendable {
    enum Method: Equatable {
        case fetchExchangeAssets
    }

    var calledMethods: [Method] = []
    nonisolated(unsafe) var fetchExchangeAssetsResult: Result<[Asset], Error>?

    nonisolated func fetchExchangeAssets(id: Int) async throws -> [Asset] {
        await MainActor.run {
            calledMethods.append(.fetchExchangeAssets)
        }

        guard let result = fetchExchangeAssetsResult else {
            fatalError("fetchExchangeAssetsResult not set")
        }

        return try result.get()
    }
}
