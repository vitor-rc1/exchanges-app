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
        let sut = makeSut(state: .loading())

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded THEN present view with partial information")
    func partialLoaded() throws {
        let sut = makeSut(state: .partialLoaded(.init(title: "Binance")))

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded AND hide chevron THEN present view with partial information")
    func partialLoadedWithouChevron() throws {
        let sut = makeSut(state: .partialLoaded(.init(title: "Binance",
                                                      hiddenChevron: true)))

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded AND hide chevron THEN present view with partial information")
    func loaded() throws {
        let infos = InfoCell.LoadedModel(url: "",
                                         title: "Binance",
                                         subtitle: "Vol: $1234.23",
                                         detail: "Date launched: 12/03/2025")
        let sut = makeSut(state: .loaded(infos))

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded THEN present view with partial information")
    func loadedWithoutChevron() throws {
        let infos = InfoCell.LoadedModel(url: "",
                                         title: "Binance",
                                         subtitle: "Vol: $1234.23",
                                         detail: "Date launched: 12/03/2025",
                                         hiddenChevron: true)
        let sut = makeSut(state: .loaded(infos))

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN loading AND 2 lines THEN present view with loading state without detail row")
    func loading2Lines() throws {
        let sut = makeSut(state: .loading(lines: 2), height: 88)

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded AND 2 lines THEN present view with partial information without detail row")
    func partialLoaded2Lines() throws {
        let sut = makeSut(state: .partialLoaded(.init(title: "Bitcoin", lines: 2)), height: 88)

        assertSnapshot(of: sut, as: .image)
    }

    @Test("GIVEN InfoCell WHEN partialLoaded AND 2 lines AND hide chevron THEN present view with partial information without detail row")
    func partialLoaded2LinesWithoutChevron() throws {
        let sut = makeSut(state: .partialLoaded(.init(title: "Bitcoin",
                                                      hiddenChevron: true,
                                                      lines: 2)), height: 88)

        assertSnapshot(of: sut, as: .image)
    }
}

extension InfoCellSnapshotTests {
    func makeSut(state: InfoCell.State, height: CGFloat = 120) -> InfoCell {
        let sut = InfoCell()
        sut.frame = CGRect(x: 0, y: 0, width: 402, height: height)
        sut.backgroundColor = .white
        sut.configure(state: state)

        return sut
    }
}
