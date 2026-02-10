//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import HomeInterfaces

struct ExchangeDetailResponse<T: Codable>: Codable {
    let status: Status
    let data: [String: T]
}
