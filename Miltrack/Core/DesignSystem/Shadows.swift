//
//  Shadows.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILShadows {
    // MARK: - Shadow Styles
    static let card = Shadow(
        color: Color.black.opacity(0.1),
        radius: 8,
        x: 0,
        y: 2
    )
    
    static let button = Shadow(
        color: Color.black.opacity(0.15),
        radius: 4,
        x: 0,
        y: 1
    )
    
    static let modal = Shadow(
        color: Color.black.opacity(0.25),
        radius: 20,
        x: 0,
        y: 10
    )
    
    static let floating = Shadow(
        color: Color.black.opacity(0.2),
        radius: 12,
        x: 0,
        y: 4
    )
}

// MARK: - Shadow Model
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extension for Shadows
extension View {
    func milShadow(_ shadow: Shadow = MILShadows.card) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}
