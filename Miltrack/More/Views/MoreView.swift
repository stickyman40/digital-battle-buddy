//
//  MoreView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MoreView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var showingProfile = false
    @State private var showingSettings = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: MILSpacing.sectionSpacing) {
                    // Profile Section
                    profileSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Support
                    supportSection
                    
                    // App Info
                    appInfoSection
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.lg)
            }
            .background(MILColors.backgroundPrimary)
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        MILCard(
            title: "Profile",
            subtitle: "Manage your account and preferences"
        ) {
            VStack(spacing: MILSpacing.md) {
                HStack {
                    // Profile Image Placeholder
                    Circle()
                        .fill(MILColors.brandPrimary.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .foregroundColor(MILColors.brandPrimary)
                        )
                    
                    VStack(alignment: .leading, spacing: MILSpacing.xs) {
                        Text(appEnvironment.currentUser?.displayName ?? "User")
                            .milTypography(.title3, weight: .semibold)
                            .foregroundColor(MILColors.textPrimary)
                        
                        Text(appEnvironment.currentUser?.email ?? "user@example.com")
                            .milTypography(.caption)
                            .foregroundColor(MILColors.textSecondary)
                        
                        if let branch = appEnvironment.currentUser?.branch {
                            MILTag(branch.rawValue, kind: .info, icon: "star")
                        }
                    }
                    
                    Spacer()
                }
                
                MILButton("Edit Profile", style: .primary, icon: "pencil") {
                    showingProfile = true
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
                MILButton("Settings", style: .secondary, icon: "gear") {
                    showingSettings = true
                }
                
                MILButton("Help & Support", style: .secondary, icon: "questionmark.circle") {
                    print("Help & support tapped")
                }
                
                MILButton("About", style: .ghost, icon: "info.circle") {
                    showingAbout = true
                }
                
                MILButton("Sign Out", style: .destructive, icon: "rectangle.portrait.and.arrow.right") {
                    Task {
                        await appEnvironment.signOut()
                    }
                }
            }
        }
    }
    
    // MARK: - Support Section
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(title: "Support")
            
            VStack(spacing: MILSpacing.sm) {
                MILCard(title: "Contact Support", subtitle: "Get help when you need it") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("24/7 Support Available")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("Response time: < 2 hours")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILButton("Contact", style: .secondary) {
                            print("Contact support tapped")
                        }
                        .frame(width: 80)
                    }
                }
                
                MILCard(title: "Feedback", subtitle: "Help us improve") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Share your thoughts")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                            Text("We value your input")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        MILButton("Submit", style: .secondary) {
                            print("Submit feedback tapped")
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
    
    // MARK: - App Info Section
    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: MILSpacing.md) {
            MILSectionHeader(title: "App Information")
            
            MILCard(title: "Digital Battle Buddy", subtitle: "Version 1.0.0") {
                VStack(spacing: MILSpacing.md) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Build")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("1.0.0 (1)")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Last Updated")
                                .milTypography(.caption)
                                .foregroundColor(MILColors.textSecondary)
                            Text("Today")
                                .milTypography(.subheadline, weight: .medium)
                                .foregroundColor(MILColors.textPrimary)
                        }
                    }
                    
                    HStack {
                        MILTag("Mock Mode", kind: .info, icon: "wrench")
                        Spacer()
                        MILButton("Check Updates", style: .ghost) {
                            print("Check updates tapped")
                        }
                        .frame(width: 120)
                    }
                }
            }
        }
    }
}

// MARK: - Placeholder Views
struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile View")
                    .milTypography(.title2)
                    .foregroundColor(MILColors.textPrimary)
                
                Text("This will contain profile editing functionality")
                    .milTypography(.body)
                    .foregroundColor(MILColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .milPadding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings View")
                    .milTypography(.title2)
                    .foregroundColor(MILColors.textPrimary)
                
                Text("This will contain app settings and preferences")
                    .milTypography(.body)
                    .foregroundColor(MILColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .milPadding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("About Digital Battle Buddy")
                    .milTypography(.title2)
                    .foregroundColor(MILColors.textPrimary)
                
                Text("A comprehensive fitness and health tracking app designed specifically for military personnel.")
                    .milTypography(.body)
                    .foregroundColor(MILColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .milPadding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MoreView()
        .environment(\.appEnvironment, AppEnvironment())
}
