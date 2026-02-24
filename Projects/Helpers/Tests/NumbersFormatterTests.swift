//
//  NumbersFormatterTests.swift
//  Helpers
//
//  Created by Vitor Conceicao on 23/02/26.
//

import Foundation
import Testing

@testable import Helpers

@Suite("StringFormatter Tests")
struct NumbersFormatterTests {
    @Test("GIVEN a value WHEN formatPrice with pt_BR locale THEN returns formatted currency string",
          arguments: [
            (1000000.50, "1.000.000,50"),
            (0.0, "0,00"),
            (1234.5, "1.234,50")
          ])
    func testFormatPriceWithPtBR(value: Double, expectedString: String) {
        let locale = Locale(identifier: "pt_BR")
        let formatter = NumbersFormatter(locale: locale)

        let result = formatter.formatPrice(value)

        #expect(result.contains(expectedString))
    }

    @Test("GIVEN a value WHEN formatPrice with en_US locale THEN returns formatted currency string",
          arguments: [
            (1000000.50, "1,000,000.50"),
            (0.0, "0.00"),
            (1234.5, "1,234.50")
          ])
    func testFormatPriceEnUs(value: Double, expectedString: String) {
        let locale = Locale(identifier: "en_US")
        let formatter = NumbersFormatter(locale: locale)

        let result = formatter.formatPrice(value)

        #expect(result.contains(expectedString))
    }
}
