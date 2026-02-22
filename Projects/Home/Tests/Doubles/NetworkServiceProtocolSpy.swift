//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import NetworkingInterfaces

actor NetworkServiceProtocolSpy: NetworkServiceProtocol, Sendable {
    enum Method: Equatable, Sendable {
        case request
    }

    private(set) var calledMethods: [Method] = []
    private(set) var requestResult: Result<(Data, HTTPURLResponse), NetworkError>?

    func request(endpoint: APIEndpointProtocol) async throws(NetworkError) -> (Data, HTTPURLResponse) {
        calledMethods.append(.request)

        guard let result = requestResult else {
            fatalError("requestResult not set")
        }

        return try result.get()
    }

    func setResponse(requestResult: Result<(Data, HTTPURLResponse), NetworkError>) async {
        self.requestResult = requestResult
    }
}
