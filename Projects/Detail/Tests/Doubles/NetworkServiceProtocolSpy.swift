//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import NetworkingInterfaces

final class NetworkServiceProtocolSpy: NetworkServiceProtocol, @unchecked Sendable {
    enum Method: Equatable {
        case request
    }

    var calledMethods: [Method] = []
    var requestResult: Result<(Data, HTTPURLResponse), Error>?

    func request(endpoint: APIEndpointProtocol) async throws -> (Data, HTTPURLResponse) {
        calledMethods.append(.request)

        guard let result = requestResult else {
            fatalError("requestResult not set")
        }

        return try result.get()
    }
}
