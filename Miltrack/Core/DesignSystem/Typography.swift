//
//  Typography.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILTypography {
    // MARK: - Font Styles
    enum FontStyle {
        case display1, display2
        case title1, title2, title3
        case headline, subheadline
        case body, bodyEmphasized
        case caption, caption2
        case monospace
    }
    
    // MARK: - Font Weights
    enum FontWeight {
        case regular, medium, semibold, bold
    }
    
    // MARK: - Font Style Helper
    static func font(_ style: FontStyle, weight: FontWeight = .regular) -> Font {
        let baseFont: Font
        
        switch style {
        case .display1:
            baseFont = .system(size: 34, weight: .bold, design: .rounded)
        case .display2:
            baseFont = .system(size: 28, weight: .bold, design: .rounded)
        case .title1:
            baseFont = .system(size: 22, weight: .semibold, design: .default)
        case .title2:
            baseFont = .system(size: 20, weight: .semibold, design: .default)
        case .title3:
            baseFont = .system(size: 18, weight: .semibold, design: .default)
        case .headline:
            baseFont = .system(size: 17, weight: .semibold, design: .default)
        case .subheadline:
            baseFont = .system(size: 15, weight: .medium, design: .default)
        case .body:
            baseFont = .system(size: 17, weight: .regular, design: .default)
        case .bodyEmphasized:
            baseFont = .system(size: 17, weight: .medium, design: .default)
        case .caption:
            baseFont = .system(size: 12, weight: .regular, design: .default)
        case .caption2:
            baseFont = .system(size: 11, weight: .regular, design: .default)
        case .monospace:
            baseFont = .system(size: 14, weight: .regular, design: .monospaced)
        }
        
        switch weight {
        case .regular:
            return baseFont
        case .medium:
            return baseFont.weight(.medium)
        case .semibold:
            return baseFont.weight(.semibold)
        case .bold:
            return baseFont.weight(.bold)
        }
    }
}

// MARK: - View Extension for Typography
extension View {
    func milTypography(_ style: MILTypography.FontStyle, weight: MILTypography.FontWeight = .regular) -> some View {
        self.font(MILTypography.font(style, weight: weight))
    }
}
