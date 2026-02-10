//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

struct ExchangeDetail: Equatable {
    let id: Int
    let name: String
    let description: String?
    let logo: String
    let spotVolumeUsd: Double?
    let makerFee: Double
    let takerFee: Double
    let dateLaunched: String
    let urls: ExchangeURLs
}

extension ExchangeDetail: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case logo
        case spotVolumeUsd = "spot_volume_usd"
        case makerFee = "maker_fee"
        case takerFee = "taker_fee"
        case dateLaunched = "date_launched"
        case urls
    }
}
