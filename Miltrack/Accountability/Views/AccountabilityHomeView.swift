//
//  AccountabilityHomeView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct AccountabilityHomeView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: MILSpacing.sectionSpacing) {
                    // Accountability Overview
                    accountabilityOverviewSection
                    
                    // My Tasks
                    myTasksSection
                    
                    // Squad Accountability
                    squadSection
                    
                    // Habits
                    habitsSection
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.lg)
            }
            .background(MILColors.backgroundPrimary)
            .navigationTitle("Accountability")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Accountability Overview Section
    private var accountabilityOverviewSection: some View {
        MILCard(
            title: "Accountability Overview",
            subtitle: "Track your progress and commitments"
        ) {
            VStack(spacing: MILSpacing.md) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Tasks Completed")
                            .milTypography(.caption)
                            .foregroundColor(MILColors.textSecondary)
                        Text("12/15")
                            .milTypography(.display2, weight: .bold)
                            .foregroundColor(MILColors.success)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Streak")
                            .milTypography(.caption)
                            .foregroundColor(MILColors.textSecondary)
                        Text("7 days")
                            .milTypography(.display2, weight: .bold)
                            .foregroundColor(MILColors.brandPrimary)
                    }
                }
                
                MILButton("View Full Report", style: .primary, icon: "chart.bar") {
                    print("View full accountability report tapped")
                }
            }
        }
    }
    
    // MARK: - My Tasks Section
    private var myTasksSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "My Tasks",
                actionTitle: "Add Task",
                action: { print("Add task tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Complete PT Test Prep", subtitle: "Due: Dec 10") {
                    HStack {
                        MILTag("High Priority", kind: .error, icon: "exclamationmark")
                        Spacer()
                        MILButton("Start", style: .primary) {
                            print("Start PT test prep tapped")
                        }
                        .frame(width: 80)
                    }
                }
                
                MILCard(title: "Update Medical Records", subtitle: "Due: Dec 15") {
                    HStack {
                        MILTag("Medium Priority", kind: .warning, icon: "clock")
                        Spacer()
                        MILButton("View", style: .secondary) {
                            print("View medical records task tapped")
                        }
                        .frame(width: 80)
                    }
                }
                
                MILCard(title: "Equipment Maintenance", subtitle: "Completed: Dec 5") {
                    HStack {
                        MILTag("Complete", kind: .success, icon: "checkmark")
                        Spacer()
                        Text("✓ Done")
                            .milTypography(.subheadline, weight: .medium)
                            .foregroundColor(MILColors.success)
                    }
                }
            }
        }
    }
    
    // MARK: - Squad Section
    private var squadSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Squad Accountability",
                actionTitle: "View Squad",
                action: { print("View squad tapped") }
            )
            
            MILCard(title: "Team Progress", subtitle: "Alpha Squad") {
                VStack(spacing: MILSpacing.md) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Team Average")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("87%")
                                .milTypography(.title2, weight: .semibold)
                                .foregroundColor(MILColors.success)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Your Rank")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("2nd")
                                .milTypography(.title2, weight: .semibold)
                                .foregroundColor(MILColors.brandPrimary)
                        }
                    }
                    
                    HStack {
                        MILTag("Top Performer", kind: .success, icon: "trophy")
                        Spacer()
                        MILButton("View Details", style: .secondary) {
                            print("View squad details tapped")
                        }
                        .frame(width: 100)
                    }
                }
            }
        }
    }
    
    // MARK: - Habits Section
    private var habitsSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Daily Habits",
                actionTitle: "Add Habit",
                action: { print("Add habit tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Morning PT", subtitle: "Daily at 6:00 AM") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("7 day streak")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("Last: Today")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILTag("Active", kind: .success, icon: "flame")
                    }
                }
                
                MILCard(title: "Hydration Goal", subtitle: "8 glasses daily") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("5 day streak")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("Last: Today")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILTag("Active", kind: .success, icon: "drop")
                    }
                }
                
                MILCard(title: "Evening Reflection", subtitle: "Daily at 9:00 PM") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("3 day streak")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("Last: Yesterday")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILTag("Needs Attention", kind: .warning, icon: "exclamationmark")
                    }
                }
            }
        }
    }
}

#Preview {
    AccountabilityHomeView()
        .environment(\.appEnvironment, AppEnvironment())
}
