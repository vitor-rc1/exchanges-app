//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation

@MainActor
public protocol ViewCode: AnyObject {
    func buildViewHierarch()
    func setUpConstraints()
    func additionalConfiguration()
}

public extension ViewCode {
    func setupView() {
        buildViewHierarch()
        setUpConstraints()
        additionalConfiguration()
    }

    func buildViewHierarch() {}
    func setUpConstraints() {}
    func additionalConfiguration() {}
}
