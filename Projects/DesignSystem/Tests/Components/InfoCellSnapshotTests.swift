//
//  InfoCellSnapshotTest.swift
//  DesignSystem
//
//  Created by Vitor Conceicao on 22/02/26.
//

import Foundation
import SnapshotTesting
import Testing

@testable import DesignSystem

@MainActor
@Suite
struct InfoCellSnapshotTests {
    @Test("GIVEN InfoCell WHEN loading THEN present view with loading state")
    func loading() throws {
        let sut = makeSut(state: .loading)

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded THEN present view with partial information")
    func partialLoaded() throws {
        let sut = makeSut(state: .partialLoaded("Binance"))

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded THEN present view with partial information")
    func loaded() throws {
        let infos = InfoCell.Model(url: "",
                                   title: "Binance",
                                   subtitle: "Vol: $1234.23",
                                   detail: "Date launched: 12/03/2025")
        let sut = makeSut(state: .loaded(infos))

        assertSnapshot(of: sut, as: .image)
    }
}

extension InfoCellSnapshotTests {
    func makeSut(state: InfoCell.State) -> InfoCell {
        let sut = InfoCell()
        sut.frame = CGRect(x: 0, y: 0, width: 402, height: 120)
        sut.backgroundColor = .white
        sut.configure(state: state)

        return sut
    }
}
