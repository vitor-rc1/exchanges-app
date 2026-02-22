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

extension Asset {
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: priceUsd)) ?? "$ 0,00"
    }
}

extension Asset: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case priceUsd = "price_usd"
    }
}
