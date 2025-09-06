//
//  DashboardView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: MILSpacing.sectionSpacing) {
                    // Welcome Section
                    welcomeSection
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Today's Tasks
                    tasksSection
                    
                    // Quick Actions
                    quickActionsSection
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.lg)
            }
            .background(MILColors.backgroundPrimary)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await viewModel.refreshData()
            }
        }
    }
    
    // MARK: - Welcome Section
    private var welcomeSection: some View {
        MILCard(
            title: "Good Morning",
            subtitle: "Ready to tackle the day?"
        ) {
            VStack(alignment: .leading, spacing: MILSpacing.md) {
                Text("Welcome back, \(appEnvironment.currentUser?.displayName ?? "Soldier")!")
                    .milTypography(.body)
                    .foregroundColor(MILColors.textPrimary)
                
                HStack {
                    MILTag("Today", kind: .info, icon: "calendar")
                    MILTag("Ready", kind: .success, icon: "checkmark")
                }
            }
        }
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Today's Overview",
                actionTitle: "View Details",
                action: { print("View details tapped") }
            )
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: MILSpacing.md) {
                MILCard(title: "Readiness", subtitle: "85%") {
                    HStack {
                        Text("85%")
                            .milTypography(.display2, weight: .bold)
                            .foregroundColor(MILColors.success)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(MILColors.success)
                    }
                }
                
                MILCard(title: "PT Score", subtitle: "Excellent") {
                    HStack {
                        Text("92")
                            .milTypography(.display2, weight: .bold)
                            .foregroundColor(MILColors.brandPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "figure.run")
                            .foregroundColor(MILColors.brandPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Tasks Section
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Today's Tasks",
                actionTitle: "View All",
                action: { print("View all tasks tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Morning PT", subtitle: "6:00 AM") {
                    HStack {
                        MILTag("Pending", kind: .warning, icon: "clock")
                        Spacer()
                        MILButton("Start", style: .primary, icon: "play.fill") {
                            print("Start PT tapped")
                        }
                        .frame(width: 80)
                    }
                }
                
                MILCard(title: "Equipment Check", subtitle: "9:00 AM") {
                    HStack {
                        MILTag("Upcoming", kind: .info, icon: "calendar")
                        Spacer()
                        MILButton("View", style: .secondary) {
                            print("View equipment check tapped")
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(title: "Quick Actions")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: MILSpacing.md) {
                MILButton("Log Workout", style: .primary, icon: "figure.run") {
                    print("Log workout tapped")
                }
                
                MILButton("Check In", style: .secondary, icon: "heart") {
                    print("Check in tapped")
                }
                
                MILButton("View Schedule", style: .ghost, icon: "calendar") {
                    print("View schedule tapped")
                }
                
                MILButton("Emergency", style: .destructive, icon: "phone") {
                    print("Emergency tapped")
                }
            }
        }
    }
}

#Preview {
    DashboardView()
        .environment(\.appEnvironment, AppEnvironment())
}
