//
//  HealthHomeView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct HealthHomeView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: MILSpacing.sectionSpacing) {
                    // Health Overview
                    healthOverviewSection
                    
                    // Sleep Tracking
                    sleepSection
                    
                    // Hydration
                    hydrationSection
                    
                    // Mental Health
                    mentalHealthSection
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.lg)
            }
            .background(MILColors.backgroundPrimary)
            .navigationTitle("Health")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Health Overview Section
    private var healthOverviewSection: some View {
        MILCard(
            title: "Health Overview",
            subtitle: "Today's summary"
        ) {
            VStack(spacing: MILSpacing.md) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Sleep Score")
                            .milTypography(.caption)
                            .foregroundColor(MILColors.textSecondary)
                        Text("85")
                            .milTypography(.display2, weight: .bold)
                            .foregroundColor(MILColors.success)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Hydration")
                            .milTypography(.caption)
                            .foregroundColor(MILColors.textSecondary)
                        Text("72%")
                            .milTypography(.display2, weight: .bold)
                            .foregroundColor(MILColors.info)
                    }
                }
                
                MILButton("View Health Report", style: .primary, icon: "heart.text.square") {
                    print("View health report tapped")
                }
            }
        }
    }
    
    // MARK: - Sleep Section
    private var sleepSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Sleep Tracking",
                actionTitle: "View Details",
                action: { print("View sleep details tapped") }
            )
            
            MILCard(title: "Last Night", subtitle: "7h 32m") {
                VStack(spacing: MILSpacing.md) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Bedtime")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("10:30 PM")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Wake Time")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("6:02 AM")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                        }
                    }
                    
                    HStack {
                        MILTag("Good Quality", kind: .success, icon: "moon.zzz")
                        Spacer()
                        MILButton("Set Goal", style: .secondary) {
                            print("Set sleep goal tapped")
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
    
    // MARK: - Hydration Section
    private var hydrationSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Hydration",
                actionTitle: "Log Water",
                action: { print("Log water tapped") }
            )
            
            MILCard(title: "Today's Intake", subtitle: "6 of 8 glasses") {
                VStack(spacing: MILSpacing.md) {
                    // Progress bar
                    VStack(alignment: .leading, spacing: MILSpacing.sm) {
                        HStack {
                            Text("Progress")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Spacer()
                            Text("75%")
                                .milTypography(.caption, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(MILColors.neutral6.opacity(0.2))
                                    .frame(height: 8)
                                    .milCornerRadius(4)
                                
                                Rectangle()
                                    .fill(MILColors.info)
                                    .frame(width: geometry.size.width * 0.75, height: 8)
                                    .milCornerRadius(4)
                            }
                        }
                        .frame(height: 8)
                    }
                    
                    MILButton("Add Water", style: .primary, icon: "drop") {
                        print("Add water tapped")
                    }
                }
            }
        }
    }
    
    // MARK: - Mental Health Section
    private var mentalHealthSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Mental Health",
                actionTitle: "Check In",
                action: { print("Mental health check in tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Daily Check-in", subtitle: "How are you feeling?") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Last Check-in")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("Yesterday")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        MILTag("Good", kind: .success, icon: "face.smiling")
                    }
                }
                
                MILCard(title: "Stress Level", subtitle: "Current assessment") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Level")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("Low")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.success)
                        }
                        
                        Spacer()
                        
                        MILButton("Assess", style: .secondary) {
                            print("Assess stress level tapped")
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
}

#Preview {
    HealthHomeView()
        .environment(\.appEnvironment, AppEnvironment())
}
