//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

enum HomeViewState: Equatable {
    case loading
    case loadingMore
    case empty
    case loaded
    case error(String, String?)
}
