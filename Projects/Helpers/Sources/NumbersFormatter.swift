//
//  NumberFormatter.swift
//  Helpers
//
//  Created by Vitor Conceicao on 23/02/26.
//

import Foundation

public struct NumbersFormatter {
    let locale: Locale

    public init(locale: Locale = .current) {
        self.locale = locale
    }

    public func formatPrice(_ value: Double?) -> String {
        guard let value else { return "-" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","

        formatter.locale = locale

        return formatter.string(from: NSNumber(value: value)) ?? "-"
    }
}
