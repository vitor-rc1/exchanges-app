//
//  DateStringFormatter.swift
//  Helpers
//
//  Created by Vitor Conceicao on 23/02/26.
//

import Foundation
import Testing

@testable import Helpers

@Suite("DateStringFormatter Tests")
struct DateStringFormatterTests {
    
    @Test("GIVEN a valid ISO8601 date string WHEN formatDate is called with custom locale THEN returns formatted date for that locale")
    func testFormatDateWithCustomLocale() {
        let dateString = "2026-02-23T15:30:00.000Z"
        let usLocale = Locale(identifier: "en_US")
        let expected = "2/23/26"

        let result = dateString.formatDate(locale: usLocale)

        #expect(result == expected)
    }

    @Test("GIVEN a date string with different locale WHEN formatDate is called with pt_BR locale THEN returns formatted date for Brazilian Portuguese")
    func testFormatDateWithBrazilianLocale() {
        let dateString = "2026-02-23T10:00:00.000Z"
        let ptBRLocale = Locale(identifier: "pt_BR")

        let result = dateString.formatDate(locale: ptBRLocale)

        let expected = "23/02/2026"

        #expect(result == expected)
    }
    
    @Test("GIVEN various invalid date strings WHEN formatDate is called THEN returns the original strings",
          arguments: [
            "invalid-date",
            "2020-13-01",
            "not a date at all",
            "12345",
            "2020/01/01"
          ])
    func testFormatDateVariousInvalidDates(dateString: String) {
        let result = dateString.formatDate()

        #expect(result == dateString)
    }
}
