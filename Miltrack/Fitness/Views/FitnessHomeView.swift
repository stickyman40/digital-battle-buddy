//
//  FitnessHomeView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct FitnessHomeView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: MILSpacing.sectionSpacing) {
                    // Fitness Overview
                    fitnessOverviewSection
                    
                    // PT Tests
                    ptTestsSection
                    
                    // Workouts
                    workoutsSection
                    
                    // Body Composition
                    bodyCompSection
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.lg)
            }
            .background(MILColors.backgroundPrimary)
            .navigationTitle("Fitness")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Fitness Overview Section
    private var fitnessOverviewSection: some View {
        MILCard(
            title: "Fitness Overview",
            subtitle: "Last updated 2 hours ago"
        ) {
            VStack(spacing: MILSpacing.md) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Current Score")
                            .milTypography(.caption)
                            .foregroundColor(MILColors.textSecondary)
                        Text("92")
                            .milTypography(.display2, weight: .bold)
                            .foregroundColor(MILColors.success)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Next Test")
                            .milTypography(.caption)
                            .foregroundColor(MILColors.textSecondary)
                        Text("Dec 15")
                            .milTypography(.title3, weight: .semibold)
                            .foregroundColor(MILColors.brandPrimary)
                    }
                }
                
                MILButton("View Full Report", style: .primary, icon: "chart.bar") {
                    print("View full report tapped")
                }
            }
        }
    }
    
    // MARK: - PT Tests Section
    private var ptTestsSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "PT Tests",
                actionTitle: "View All",
                action: { print("View all PT tests tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Army PFT", subtitle: "November 2024") {
                    HStack {
                        MILTag("Passed", kind: .success, icon: "checkmark")
                        Spacer()
                        Text("Score: 285")
                            .milTypography(.subheadline, weight: .medium)
                            .foregroundColor(MILColors.textPrimary)
                    }
                }
                
                MILCard(title: "Next Test", subtitle: "December 15, 2024") {
                    HStack {
                        MILTag("Scheduled", kind: .info, icon: "calendar")
                        Spacer()
                        MILButton("Prepare", style: .secondary) {
                            print("Prepare for test tapped")
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
    
    // MARK: - Workouts Section
    private var workoutsSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Recent Workouts",
                actionTitle: "Log Workout",
                action: { print("Log workout tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Morning Run", subtitle: "Today, 6:00 AM") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("3.2 miles")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("24:15")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILTag("Complete", kind: .success, icon: "checkmark")
                    }
                }
                
                MILCard(title: "Strength Training", subtitle: "Yesterday") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Upper Body")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("45 minutes")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILTag("Complete", kind: .success, icon: "checkmark")
                    }
                }
            }
        }
    }
    
    // MARK: - Body Composition Section
    private var bodyCompSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Body Composition",
                actionTitle: "Update",
                action: { print("Update body comp tapped") }
            )
            
            MILCard(title: "Current Stats", subtitle: "Last measured: Nov 20") {
                VStack(spacing: MILSpacing.md) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Weight")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("185 lbs")
                                .milTypography(.title3, weight: .semibold)
                                .foregroundColor(MILColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Body Fat")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("12%")
                                .milTypography(.title3, weight: .semibold)
                                .foregroundColor(MILColors.success)
                        }
                    }
                    
                    MILButton("Log New Measurement", style: .secondary, icon: "plus") {
                        print("Log new measurement tapped")
                    }
                }
            }
        }
    }
}

#Preview {
    FitnessHomeView()
        .environment(\.appEnvironment, AppEnvironment())
}
