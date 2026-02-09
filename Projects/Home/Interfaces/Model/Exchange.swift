//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

public struct Exchange: Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let description: String?
    public let logo: String
    public let spotVolumeUsd: Double?
    public let makerFee: Double
    public let takerFee: Double
    public let dateLaunched: String
    public let websiteUrl: String?
    public let twitterUrl: String?

    public let isLoadingDetails: Bool

    public init(id: Int,
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

    public init(summary: ExchangeSummary) {
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
