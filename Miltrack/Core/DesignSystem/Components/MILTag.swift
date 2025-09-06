//
//  MILTag.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILTag: View {
    enum Kind {
        case success
        case warning
        case error
        case info
        case neutral
    }
    
    let text: String
    let kind: Kind
    let icon: String?
    
    init(
        _ text: String,
        kind: Kind = .neutral,
        icon: String? = nil
    ) {
        self.text = text
        self.kind = kind
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: MILSpacing.xs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
            }
            
            Text(text)
                .milTypography(.caption2, weight: .medium)
        }
        .milPadding(.horizontal, MILSpacing.sm)
        .milPadding(.vertical, MILSpacing.xs)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .milCornerRadius(MILRadii.tag)
    }
    
    private var backgroundColor: Color {
        switch kind {
        case .success:
            return MILColors.success.opacity(0.1)
        case .warning:
            return MILColors.warning.opacity(0.1)
        case .error:
            return MILColors.error.opacity(0.1)
        case .info:
            return MILColors.info.opacity(0.1)
        case .neutral:
            return MILColors.neutral6.opacity(0.1)
        }
    }
    
    private var foregroundColor: Color {
        switch kind {
        case .success:
            return MILColors.success
        case .warning:
            return MILColors.warning
        case .error:
            return MILColors.error
        case .info:
            return MILColors.info
        case .neutral:
            return MILColors.textSecondary
        }
    }
}

#Preview {
    VStack(spacing: MILSpacing.md) {
        HStack(spacing: MILSpacing.sm) {
            MILTag("Complete", kind: .success, icon: "checkmark")
            MILTag("Pending", kind: .warning, icon: "clock")
            MILTag("Failed", kind: .error, icon: "xmark")
        }
        
        HStack(spacing: MILSpacing.sm) {
            MILTag("Info", kind: .info, icon: "info.circle")
            MILTag("Neutral", kind: .neutral)
        }
        
        HStack(spacing: MILSpacing.sm) {
            MILTag("PT Test")
            MILTag("Fitness", icon: "figure.run")
            MILTag("Health", icon: "heart")
        }
    }
    .milPadding()
    .background(MILColors.backgroundPrimary)
}
