//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

struct ExchangeResponse<T: Codable>: Codable {
    let status: Status
    let data: [T]
}
