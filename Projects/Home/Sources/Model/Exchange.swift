//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

struct Exchange: Equatable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let logo: String
    let spotVolumeUsd: Double?
    let makerFee: Double
    let takerFee: Double
    let dateLaunched: String
    let websiteUrl: String?
    let twitterUrl: String?

    let isLoadingDetails: Bool

    init(id: Int,
         name: String,
         description: String? = nil,
         logo: String,
         spotVolumeUsd: Double? = nil,
         makerFee: Double,
         takerFee: Double,
         dateLaunched: String,
         websiteUrl: String? = nil,
         twitterUrl: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.logo = logo
        self.spotVolumeUsd = spotVolumeUsd
        self.makerFee = makerFee
        self.takerFee = takerFee
        self.dateLaunched = dateLaunched
        self.websiteUrl = websiteUrl
        self.twitterUrl = twitterUrl
        self.isLoadingDetails = false
    }

    init(summary: ExchangeSummary) {
        self.id = summary.id
        self.name = summary.name
        self.description = nil
        self.logo = ""
        self.spotVolumeUsd = nil
        self.makerFee = 0.0
        self.takerFee = 0.0
        self.dateLaunched = ""
        self.websiteUrl = nil
        self.twitterUrl = nil
        self.isLoadingDetails = true
    }
}
