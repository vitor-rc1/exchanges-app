//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

enum DetailViewState: Equatable {
    case loading
    case loaded(ExchangeDetailModel)
    case loadingAssets
    case loadedAssets
    case error(String)
    case errorLoadAssets(title: String, message: String, code: Int)
}
