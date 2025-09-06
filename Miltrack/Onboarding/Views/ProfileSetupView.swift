//
//  ProfileSetupView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            progressBar
            ScrollView {
                VStack(spacing: MILSpacing.xl) {
                    headerSection
                    profileFormSection
                    infoCardSection
                }
            }
            bottomActionsSection
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
        .onChange(of: viewModel.currentState) { _, newState in
            if newState == .complete {
                appEnvironment.isAuthenticated = true
            }
        }
    }
    
    // MARK: - View Components
    
    private var progressBar: some View {
        ProgressView(value: viewModel.progressPercentage)
            .progressViewStyle(LinearProgressViewStyle(tint: MILColors.accent))
            .milPadding(.horizontal, MILSpacing.screenPadding)
            .milPadding(.top, MILSpacing.md)
    }
    
    private var headerSection: some View {
        VStack(spacing: MILSpacing.md) {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 60))
                .foregroundColor(MILColors.accent)
            
            Text("Complete Your Profile")
                .font(MILTypography.font(.display2))
                .foregroundColor(MILColors.neutral9)
            
            Text("Tell us about your military service to personalize your experience")
                .font(MILTypography.font(.body))
                .foregroundColor(MILColors.neutral6)
                .multilineTextAlignment(.center)
        }
        .milPadding(.top, MILSpacing.xl)
    }
    
    private var profileFormSection: some View {
        VStack(spacing: MILSpacing.lg) {
            serviceBranchPicker
            rankPicker
            unitTextField
        }
        .milPadding(.horizontal, MILSpacing.screenPadding)
    }
    
    private var serviceBranchPicker: some View {
        VStack(alignment: .leading, spacing: MILSpacing.sm) {
            Text("Service Branch")
                .font(MILTypography.font(.headline))
                .foregroundColor(MILColors.neutral9)
            
            Picker("Service Branch", selection: Binding(
                get: { viewModel.profileData.branch },
                set: { viewModel.updateBranch($0 ?? .army) }
            )) {
                Text("Select Branch").tag(nil as ServiceBranch?)
                ForEach(ServiceBranch.allCases, id: \.self) { branch in
                    Text(branch.rawValue).tag(branch as ServiceBranch?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .milPadding(.all, MILSpacing.md)
            .background(MILColors.neutral2)
            .milCornerRadius(MILRadii.button)
        }
    }
    
    private var rankPicker: some View {
        VStack(alignment: .leading, spacing: MILSpacing.sm) {
            Text("Rank")
                .font(MILTypography.font(.headline))
                .foregroundColor(MILColors.neutral9)
            
            Picker("Rank", selection: Binding(
                get: { viewModel.profileData.rank },
                set: { viewModel.updateRank($0 ?? "") }
            )) {
                Text("Select Rank").tag(nil as String?)
                ForEach(MilitaryRank.allCases, id: \.self) { rank in
                    Text(rank.displayName).tag(rank.rawValue as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .milPadding(.all, MILSpacing.md)
            .background(MILColors.neutral2)
            .milCornerRadius(MILRadii.button)
        }
    }
    
    private var unitTextField: some View {
        VStack(alignment: .leading, spacing: MILSpacing.sm) {
            Text("Unit")
                .font(MILTypography.font(.headline))
                .foregroundColor(MILColors.neutral9)
            
            TextField("Enter your unit", text: Binding(
                get: { viewModel.profileData.unit ?? "" },
                set: { viewModel.updateUnit($0) }
            ))
            .milPadding(.all, MILSpacing.md)
            .background(MILColors.neutral2)
            .milCornerRadius(MILRadii.button)
            .foregroundColor(MILColors.neutral9)
        }
    }
    
    private var infoCardSection: some View {
        MILCard(title: "Why We Need This", subtitle: "Personalization & Features") {
            VStack(alignment: .leading, spacing: MILSpacing.sm) {
                Text("• Customize PT test standards for your branch")
                Text("• Access branch-specific tools and resources")
                Text("• Connect with others in your unit")
                Text("• Track progress with relevant benchmarks")
            }
            .font(MILTypography.font(.caption))
            .foregroundColor(MILColors.neutral6)
        }
        .milPadding(.horizontal, MILSpacing.screenPadding)
    }
    
    private var bottomActionsSection: some View {
        VStack(spacing: MILSpacing.md) {
            MILButton(
                "Complete Setup",
                style: .primary
            ) {
                Task {
                    await viewModel.saveProfile()
                }
            }
            .disabled(!viewModel.canProceedFromProfile || viewModel.isLoading)
            .accessibilityLabel("Complete setup button")
            
            MILButton(
                "Skip for Now",
                style: .ghost
            ) {
                viewModel.completeOnboarding()
            }
            .accessibilityLabel("Skip profile setup button")
        }
        .milPadding(.horizontal, MILSpacing.screenPadding)
        .milPadding(.bottom, MILSpacing.xl)
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
            .environment(\.appEnvironment, AppEnvironment.mock)
    }
}
