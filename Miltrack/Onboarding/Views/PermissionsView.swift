//
//  PermissionsView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct PermissionsView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            ProgressView(value: viewModel.progressPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: MILColors.accent))
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.md)
            
            ScrollView {
                VStack(spacing: MILSpacing.xl) {
                    // Header
                    VStack(spacing: MILSpacing.md) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 60))
                            .foregroundColor(MILColors.accent)
                        
                        Text("Permissions")
                            .font(MILTypography.font(.display2))
                            .foregroundColor(MILColors.neutral9)
                        
                        Text("Grant permissions to unlock the full potential of Miltrack")
                            .font(MILTypography.font(.body))
                            .foregroundColor(MILColors.neutral6)
                            .multilineTextAlignment(.center)
                    }
                    .milPadding(.top, MILSpacing.xl)
                    
                    // Permission Cards
                    VStack(spacing: MILSpacing.lg) {
                        ForEach(viewModel.permissions, id: \.id) { permission in
                            PermissionCard(
                                permission: permission,
                                isGranted: permission.isGranted
                            ) {
                                viewModel.togglePermission(permission.id)
                            }
                        }
                    }
                    .milPadding(.horizontal, MILSpacing.screenPadding)
                    
                    // Info Card
                    MILCard(title: "Privacy First", subtitle: "Your data is secure") {
                        VStack(alignment: .leading, spacing: MILSpacing.sm) {
                            Text("• All data is encrypted and stored securely")
                            Text("• You can revoke permissions anytime in Settings")
                            Text("• We never share your personal information")
                        }
                        .font(MILTypography.font(.caption))
                        .foregroundColor(MILColors.neutral6)
                    }
                    .milPadding(.horizontal, MILSpacing.screenPadding)
                }
            }
            
            // Bottom Actions
            VStack(spacing: MILSpacing.md) {
                MILButton(
                    "Continue",
                    style: .primary
                ) {
                    Task {
                        await viewModel.requestPermissions()
                        viewModel.continueFromPermissions()
                    }
                }
                .disabled(viewModel.isLoading)
                .accessibilityLabel("Continue button")
                
                MILButton(
                    "Skip for Now",
                    style: .ghost
                ) {
                    viewModel.continueFromPermissions()
                }
                .accessibilityLabel("Skip permissions button")
            }
            .milPadding(.horizontal, MILSpacing.screenPadding)
            .milPadding(.bottom, MILSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MILColors.neutral0.ignoresSafeArea())
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
        .onChange(of: viewModel.errorMessage) { _, errorMessage in
            if errorMessage != nil {
                showingAlert = true
            }
        }
    }
}

struct PermissionCard: View {
    let permission: Permission
    let isGranted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        MILCard {
            HStack(spacing: MILSpacing.md) {
                // Icon
                Image(systemName: permission.systemImage)
                    .font(.system(size: 24))
                    .foregroundColor(isGranted ? MILColors.success : MILColors.neutral6)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isGranted ? MILColors.success.opacity(0.1) : MILColors.neutral6.opacity(0.1))
                    )
                
                // Content
                VStack(alignment: .leading, spacing: MILSpacing.xs) {
                    Text(permission.title)
                        .font(MILTypography.font(.headline))
                        .foregroundColor(MILColors.neutral9)
                    
                    Text(permission.description)
                        .font(MILTypography.font(.caption))
                        .foregroundColor(MILColors.neutral6)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Toggle
                Toggle("", isOn: .constant(isGranted))
                    .toggleStyle(SwitchToggleStyle(tint: MILColors.accent))
                    .onChange(of: isGranted) { _, _ in
                        onToggle()
                    }
            }
        }
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
            .environment(\.appEnvironment, AppEnvironment.mock)
    }
}
