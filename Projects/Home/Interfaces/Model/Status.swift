//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

public struct StatusResponse: Equatable, Sendable, Codable {
    public let status: Status
}

public struct Status: Equatable, Sendable {
    public let timestamp: String
    public let errorCode: Int?
    public let errorMessage: String?
    public let elapsed: Int
    public let creditCount: Int

    public init(timestamp: String,
                errorCode: Int? = nil,
                errorMessage: String? = nil,
                elapsed: Int,
                creditCount: Int) {
        self.timestamp = timestamp
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.elapsed = elapsed
        self.creditCount = creditCount
    }
}

extension Status: Codable {
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
    }
}
