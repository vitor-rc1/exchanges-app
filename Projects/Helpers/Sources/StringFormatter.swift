//
//  DateStringFormatter.swift
//  Helpers
//
//  Created by Vitor Conceicao on 23/02/26.
//

import Foundation

public struct StringFormatter {
    let locale: Locale

    public init(locale: Locale = .current) {
        self.locale = locale
    }

    public func formatDate(_ date: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: date) else {
            return date
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .none
        displayFormatter.locale = locale

        return displayFormatter.string(from: date)
    }
}
