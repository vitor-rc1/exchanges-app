//
//  DateStringFormatter.swift
//  Helpers
//
//  Created by Vitor Conceicao on 23/02/26.
//

import Foundation

public extension String {
    func formatDate(locale: Locale = .current) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: self) else {
            return self
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .none
        displayFormatter.locale = locale

        return displayFormatter.string(from: date)
    }
}
