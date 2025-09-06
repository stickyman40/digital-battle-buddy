//
//  Colors.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILColors {
    // MARK: - Brand Colors
    static let brandPrimary = Color(hex: "#2C4A3F")      // Deep green
    static let brandSecondary = Color(hex: "#7A8F7A")    // Sage
    static let accent = Color(hex: "#D4AF37")            // Gold
    
    // MARK: - Neutral Colors
    static let neutral0 = Color(hex: "#0A0B0A")          // Darkest
    static let neutral1 = Color(hex: "#171A18")          // Dark
    static let neutral2 = Color(hex: "#232725")          // Medium dark
    static let neutral6 = Color(hex: "#8C948F")          // Medium
    static let neutral9 = Color(hex: "#F3F5F3")          // Lightest
    
    // MARK: - Semantic Colors
    static let success = Color(hex: "#2E7D32")           // Green
    static let warning = Color(hex: "#ED6C02")           // Orange
    static let error = Color(hex: "#B00020")             // Red
    static let info = Color(hex: "#1976D2")              // Blue
    
    // MARK: - Background Colors
    static let backgroundPrimary = neutral9
    static let backgroundSecondary = Color.white
    static let backgroundTertiary = neutral1
    
    // MARK: - Text Colors
    static let textPrimary = neutral0
    static let textSecondary = neutral2
    static let textTertiary = neutral6
    static let textInverse = neutral9
    
    // MARK: - Border Colors
    static let borderPrimary = neutral6
    static let borderSecondary = Color(hex: "#E0E0E0")
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
