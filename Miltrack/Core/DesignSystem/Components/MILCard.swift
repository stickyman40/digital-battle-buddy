//
//  MILCard.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILCard<Content: View>: View {
    let title: String?
    let subtitle: String?
    let content: () -> Content
    let action: (() -> Void)?
    
    init(
        title: String? = nil,
        subtitle: String? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            // Header
            if let title = title {
                HStack {
                    VStack(alignment: .leading, spacing: MILSpacing.xs) {
                        Text(title)
                            .milTypography(.title3, weight: .semibold)
                            .foregroundColor(MILColors.textPrimary)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    if let action = action {
                        Button(action: action) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(MILColors.textTertiary)
                        }
                    }
                }
            }
            
            // Content
            content()
        }
        .milPadding(.all, MILSpacing.cardPadding)
        .background(MILColors.backgroundSecondary)
        .milCornerRadius(MILRadii.card)
        .milShadow(MILShadows.card)
    }
}

// MARK: - Convenience Initializers
extension MILCard where Content == EmptyView {
    init(
        title: String? = nil,
        subtitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.content = { EmptyView() }
    }
}

#Preview {
    VStack(spacing: MILSpacing.lg) {
        MILCard(
            title: "Readiness Score",
            subtitle: "Updated 2 hours ago",
            action: { print("Card tapped") }
        ) {
            HStack {
                Text("85%")
                    .milTypography(.display2, weight: .bold)
                    .foregroundColor(MILColors.success)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Excellent")
                        .milTypography(.caption, weight: .medium)
                        .foregroundColor(MILColors.success)
                    Text("Keep it up!")
                        .milTypography(.caption2)
                        .foregroundColor(MILColors.textSecondary)
                }
            }
        }
        
        MILCard(title: "Simple Card") {
            Text("This is a simple card with just content.")
                .milTypography(.body)
                .foregroundColor(MILColors.textPrimary)
        }
    }
    .milPadding()
    .background(MILColors.backgroundPrimary)
}
