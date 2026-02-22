//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Foundation
import SnapshotTesting
import Testing

@testable import DesignSystem

@MainActor
@Suite
struct ErrorViewSnapshotTest {
    @Test("GIVEN ErrorView THEN it should configure with default values")
    func testConfigureDefaultValues() throws {
        let sut = makeSut(title: "Failed to load Exchanges",
                          message: "Our server is experiencing problems.\nPlease try again.")

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN ErrorView THEN it should configure with code and buttons")
    func testConfigureCode() throws {
        let sut = makeSut(title: "Failed to load Exchanges",
                          message: "Our server is experiencing problems.\nPlease try again.",
                          code: "500",
                          buttonText: "Back")

        assertSnapshot(of: sut, as: .image)
    }

    func makeSut(title: String,
                 message: String,
                 code: String? = nil,
                 buttonText: String? = nil) -> ErrorView {
        let sut = ErrorView()
        sut.frame = CGRect(x: 0, y: 0, width: 402, height: 874)
        sut.backgroundColor = .white
        sut.configure(title: title,
                      message: message,
                      code: code,
                      buttonText: buttonText)
        sut.setNeedsLayout()
        sut.layoutIfNeeded()

        return sut
    }
}
