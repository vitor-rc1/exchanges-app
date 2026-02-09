//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

public struct Status: Equatable {
    let timestamp: String
    let errorCode: Int?
    let errorMessage: String?
    let elapsed: Int
    let creditCount: Int
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
