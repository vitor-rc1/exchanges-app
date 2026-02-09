//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import NetworkingInterfaces
import Foundation

enum DetailEndpoint: APIEndpointProtocol {
    case fetchAssets(id: Int)

    var baseURL: String {
        ProcessInfo.processInfo.environment["CM_API_BASE_URL"] ?? ""
    }

    var path: String {
        switch self {
        case let .fetchAssets(id):
            return "/v1/exchange/assets?id=\(id)"
        }
    }

    var method: NetworkingInterfaces.HTTPMethod {
        .get
    }

    var headers: [String: String]? {
        [
            "X-CMC_PRO_API_KEY": ProcessInfo.processInfo.environment["CM_API_KEY"] ?? ""
        ]
    }
}
