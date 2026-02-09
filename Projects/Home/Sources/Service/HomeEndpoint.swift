//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import NetworkingInterfaces
import Foundation

enum HomeEndpoint: APIEndpointProtocol {
    case fetchItems(page: Int, limit: Int)
    case fetchDetail(ids: [String])

    var baseURL: String {
        ProcessInfo.processInfo.environment["CM_API_BASE_URL"] ?? ""
    }

    var path: String {
        let basePath: String = "/v1/exchange/"
        switch self {
        case let .fetchItems(page, limit):
            return "\(basePath)map?start=\(page)&limit=\(limit)"
        case let .fetchDetail(ids):
            let idsQuery = ids.joined(separator: ",")
            return "\(basePath)info?id=\(idsQuery)"
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
