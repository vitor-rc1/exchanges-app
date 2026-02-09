//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

struct Asset: Sendable, Equatable {
    let id: Int
    let name: String
    let symbol: String
    let priceUsd: Double
}

extension Asset: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case priceUsd = "price_usd"
    }
}
