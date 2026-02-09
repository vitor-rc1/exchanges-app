//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces

struct ExchangeAssetsResponse: Codable, Equatable {
    let status: Status
    let data: [AssetResponse]
}

struct AssetResponse: Codable, Equatable {
    let walletAddress: String
    let balance: Double
    let currency: Currency

    enum CodingKeys: String, CodingKey {
        case walletAddress = "wallet_address"
        case balance
        case currency
    }
}

struct Currency: Codable, Equatable {
    let cryptoId: Int
    let priceUsd: Double
    let symbol: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case cryptoId = "crypto_id"
        case priceUsd = "price_usd"
        case symbol
        case name
    }
}
