//
//  ToolsHomeView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct ToolsHomeView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: MILSpacing.sectionSpacing) {
                    // Tools Overview
                    toolsOverviewSection
                    
                    // Converters
                    convertersSection
                    
                    // Time Zone
                    timeZoneSection
                    
                    // Checklists
                    checklistsSection
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.lg)
            }
            .background(MILColors.backgroundPrimary)
            .navigationTitle("Tools")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Tools Overview Section
    private var toolsOverviewSection: some View {
        MILCard(
            title: "Utility Tools",
            subtitle: "Quick access to helpful tools"
        ) {
            VStack(spacing: MILSpacing.md) {
                Text("Essential tools for military personnel")
                    .milTypography(.body)
                    .foregroundColor(MILColors.textPrimary)
                
                HStack {
                    MILTag("Converters", kind: .info, icon: "arrow.left.arrow.right")
                    MILTag("Time Zones", kind: .info, icon: "clock")
                    MILTag("Checklists", kind: .info, icon: "checklist")
                }
            }
        }
    }
    
    // MARK: - Converters Section
    private var convertersSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Converters",
                actionTitle: "View All",
                action: { print("View all converters tapped") }
            )
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: MILSpacing.md) {
                MILCard(title: "Distance", subtitle: "Miles ↔ Kilometers") {
                    VStack(spacing: MILSpacing.sm) {
                        Text("1 mi = 1.61 km")
                            .milTypography(.caption, weight: .medium)
                            .foregroundColor(MILColors.textSecondary)
                        
                        MILButton("Convert", style: .secondary, icon: "arrow.left.arrow.right") {
                            print("Distance converter tapped")
                        }
                    }
                }
                
                MILCard(title: "Temperature", subtitle: "Fahrenheit ↔ Celsius") {
                    VStack(spacing: MILSpacing.sm) {
                        Text("32°F = 0°C")
                            .milTypography(.caption, weight: .medium)
                            .foregroundColor(MILColors.textSecondary)
                        
                        MILButton("Convert", style: .secondary, icon: "thermometer") {
                            print("Temperature converter tapped")
                        }
                    }
                }
                
                MILCard(title: "Weight", subtitle: "Pounds ↔ Kilograms") {
                    VStack(spacing: MILSpacing.sm) {
                        Text("1 lb = 0.45 kg")
                            .milTypography(.caption, weight: .medium)
                            .foregroundColor(MILColors.textSecondary)
                        
                        MILButton("Convert", style: .secondary, icon: "scalemass") {
                            print("Weight converter tapped")
                        }
                    }
                }
                
                MILCard(title: "Speed", subtitle: "MPH ↔ KPH") {
                    VStack(spacing: MILSpacing.sm) {
                        Text("1 mph = 1.61 kph")
                            .milTypography(.caption, weight: .medium)
                            .foregroundColor(MILColors.textSecondary)
                        
                        MILButton("Convert", style: .secondary, icon: "speedometer") {
                            print("Speed converter tapped")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Time Zone Section
    private var timeZoneSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Time Zones",
                actionTitle: "Add Location",
                action: { print("Add time zone location tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Current Location", subtitle: "Local Time") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("12:34 PM")
                                .milTypography(.title2, weight: .semibold)
                                .foregroundColor(MILColors.textPrimary)
                            Text("EST")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILTag("Local", kind: .success, icon: "location")
                    }
                }
                
                MILCard(title: "UTC", subtitle: "Coordinated Universal Time") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("5:34 PM")
                                .milTypography(.title2, weight: .semibold)
                                .foregroundColor(MILColors.textPrimary)
                            Text("UTC")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILTag("+5h", kind: .info, icon: "clock")
                    }
                }
            }
        }
    }
    
    // MARK: - Checklists Section
    private var checklistsSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(
                title: "Checklists",
                actionTitle: "Create New",
                action: { print("Create new checklist tapped") }
            )
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Uniform Inspection", subtitle: "Daily checklist") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("8 of 12 items")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("67% complete")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILButton("Continue", style: .secondary) {
                            print("Continue uniform checklist tapped")
                        }
                        .frame(width: 80)
                    }
                }
                
                MILCard(title: "Packing List", subtitle: "Deployment essentials") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("15 of 20 items")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("75% complete")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILButton("View", style: .secondary) {
                            print("View packing list tapped")
                        }
                        .frame(width: 80)
                    }
                }
                
                MILCard(title: "Equipment Check", subtitle: "Weekly maintenance") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Not started")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textSecondary)
                            Text("Due tomorrow")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.warning)
                        }
                        
                        Spacer()
                        
                        MILButton("Start", style: .primary) {
                            print("Start equipment check tapped")
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
}

#Preview {
    ToolsHomeView()
        .environment(\.appEnvironment, AppEnvironment())
}
