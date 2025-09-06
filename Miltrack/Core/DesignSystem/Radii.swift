//
//  Radii.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILRadii {
    // MARK: - Border Radius Scale
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let round: CGFloat = 50
    
    // MARK: - Semantic Radii
    static let card: CGFloat = md
    static let button: CGFloat = sm
    static let input: CGFloat = sm
    static let modal: CGFloat = xl
    static let tag: CGFloat = round
}

// MARK: - View Extension for Corner Radius
extension View {
    func milCornerRadius(_ radius: CGFloat = MILRadii.md) -> some View {
        self.cornerRadius(radius)
    }
}
