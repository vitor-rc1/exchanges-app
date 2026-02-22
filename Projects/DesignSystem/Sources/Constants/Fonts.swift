//
//  Fonts.swift
//  DesignSystem
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//

import UIKit

public enum DSFonts {
    // MARK: - Title
    public static let titl2eRegular: UIFont = .preferredFont(forTextStyle: .title2)
    public static let title3Emphasized: UIFont = .systemFont(ofSize: 20, weight: .semibold)

    // MARK: - Body
    public static let bodyRegular: UIFont = .preferredFont(forTextStyle: .body)

    // MARK: - Subheadline
    public static let subheadlineRegular: UIFont = .preferredFont(forTextStyle: .subheadline)

    // MARK: - Callout
    public static let calloutRegular: UIFont = .preferredFont(forTextStyle: .callout)
    public static let calloutEmphasized: UIFont = .systemFont(ofSize: 16, weight: .semibold)

    // MARK: - Caption
    public static let captionRegular: UIFont = .preferredFont(forTextStyle: .caption1)

    // MARK: - Footnote
    public static let footnoteRegular: UIFont = .preferredFont(forTextStyle: .footnote)
}
