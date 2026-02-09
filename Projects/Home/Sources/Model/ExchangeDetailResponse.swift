//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

struct ExchangeDetailResponse<T: Codable>: Codable {
    let status: Status
    let data: [String: T]
}
