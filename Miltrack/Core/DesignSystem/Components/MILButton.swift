//
//  MILButton.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILButton: View {
    enum Style {
        case primary
        case secondary
        case ghost
        case destructive
    }
    
    let title: String
    let style: Style
    let icon: String?
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        _ title: String,
        style: Style = .primary,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: MILSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .milTypography(.headline, weight: .semibold)
            }
            .milPadding(.horizontal, MILSpacing.lg)
            .milPadding(.vertical, MILSpacing.md)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .milCornerRadius(MILRadii.button)
            .overlay(
                RoundedRectangle(cornerRadius: MILRadii.button)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .conditionalModifier(style == .primary) { view in
                view.milShadow(MILShadows.button)
            }
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return MILColors.brandPrimary
        case .secondary:
            return MILColors.backgroundSecondary
        case .ghost:
            return Color.clear
        case .destructive:
            return MILColors.error
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return MILColors.textInverse
        case .secondary:
            return MILColors.brandPrimary
        case .ghost:
            return MILColors.brandPrimary
        case .destructive:
            return MILColors.textInverse
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary, .destructive:
            return Color.clear
        case .secondary:
            return MILColors.borderPrimary
        case .ghost:
            return MILColors.brandPrimary
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .destructive:
            return 0
        case .secondary, .ghost:
            return 1
        }
    }
}

#Preview {
    VStack(spacing: MILSpacing.lg) {
        MILButton("Primary Button", style: .primary, icon: "plus") {
            print("Primary tapped")
        }
        
        MILButton("Secondary Button", style: .secondary, icon: "gear") {
            print("Secondary tapped")
        }
        
        MILButton("Ghost Button", style: .ghost) {
            print("Ghost tapped")
        }
        
        MILButton("Destructive Button", style: .destructive, icon: "trash") {
            print("Destructive tapped")
        }
    }
    .milPadding()
    .background(MILColors.backgroundPrimary)
}
