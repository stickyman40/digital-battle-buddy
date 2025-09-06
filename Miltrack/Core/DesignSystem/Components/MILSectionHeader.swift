//
//  MILSectionHeader.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MILSectionHeader: View {
    let title: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        title: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(title)
                .milTypography(.title2, weight: .semibold)
                .foregroundColor(MILColors.textPrimary)
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .milTypography(.subheadline, weight: .medium)
                        .foregroundColor(MILColors.brandPrimary)
                }
            }
        }
        .milPadding(.horizontal, MILSpacing.screenPadding)
        .milPadding(.vertical, MILSpacing.sm)
    }
}

#Preview {
    VStack(spacing: MILSpacing.lg) {
        MILSectionHeader(
            title: "Today's Tasks",
            actionTitle: "View All",
            action: { print("View all tapped") }
        )
        
        MILSectionHeader(title: "Quick Actions")
        
        MILSectionHeader(
            title: "Recent Activity",
            actionTitle: "See More",
            action: { print("See more tapped") }
        )
    }
    .background(MILColors.backgroundPrimary)
}
