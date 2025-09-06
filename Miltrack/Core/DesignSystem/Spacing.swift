//
//  Spacing.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILSpacing {
    // MARK: - Spacing Scale
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let xxxxl: CGFloat = 40
    
    // MARK: - Semantic Spacing
    static let cardPadding: CGFloat = lg
    static let sectionSpacing: CGFloat = xl
    static let itemSpacing: CGFloat = md
    static let buttonPadding: CGFloat = lg
    static let screenPadding: CGFloat = lg
}

// MARK: - View Extension for Spacing
extension View {
    func milPadding(_ edges: Edge.Set = .all, _ spacing: CGFloat = MILSpacing.lg) -> some View {
        self.padding(edges, spacing)
    }
}
