//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces

struct ExchangeDetailModel: Equatable {
    let id: Int
    let name: String
    let description: String
    let logoUrl: String
    let spotVolumeUsd: String
    let makerFee: Double
    let takerFee: Double
    let dateLaunched: String
    let websiteUrl: String?
    let twitterUrl: String?
}

extension ExchangeDetailModel {
    init(from exchangeDetail: Exchange) {
        self.init(
            id: exchangeDetail.id,
            name: exchangeDetail.name,
            description: exchangeDetail.description ?? "No description available",
            logoUrl: exchangeDetail.logo,
            spotVolumeUsd: exchangeDetail.spotVolumeUsd,
            makerFee: exchangeDetail.makerFee,
            takerFee: exchangeDetail.takerFee,
            dateLaunched: exchangeDetail.dateLaunched,
            websiteUrl: exchangeDetail.websiteUrl,
            twitterUrl: exchangeDetail.twitterUrl
        )
    }
}
