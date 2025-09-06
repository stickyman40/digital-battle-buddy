//
//  AuthGateView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct AuthGateView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var showingEmailAuth = false
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
                        Image(systemName: "person.badge.shield.checkmark")
                            .font(.system(size: 60))
                            .foregroundColor(MILColors.accent)
                        
                        Text("Sign In")
                            .font(MILTypography.font(.display2))
                            .foregroundColor(MILColors.neutral9)
                        
                        Text("Choose your preferred sign-in method to get started")
                            .font(MILTypography.font(.body))
                            .foregroundColor(MILColors.neutral6)
                            .multilineTextAlignment(.center)
                    }
                    .milPadding(.top, MILSpacing.xl)
                    
                    // Auth Options
                    VStack(spacing: MILSpacing.lg) {
                        // Sign in with Apple
                        MILButton(
                            "Continue with Apple",
                            style: .primary,
                            icon: "applelogo"
                        ) {
                            Task {
                                await signInWithApple()
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .accessibilityLabel("Sign in with Apple button")
                        
                        // Email Sign In
                        MILButton(
                            "Continue with Email",
                            style: .secondary
                        ) {
                            showingEmailAuth = true
                        }
                        .accessibilityLabel("Sign in with email button")
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(MILColors.neutral6)
                                .frame(height: 1)
                            
                            Text("or")
                                .font(MILTypography.font(.caption))
                                .foregroundColor(MILColors.neutral6)
                                .milPadding(.horizontal, MILSpacing.md)
                            
                            Rectangle()
                                .fill(MILColors.neutral6)
                                .frame(height: 1)
                        }
                        .milPadding(.vertical, MILSpacing.md)
                        
                        // Guest Mode
                        MILButton(
                            "Continue as Guest",
                            style: .ghost
                        ) {
                            continueAsGuest()
                        }
                        .accessibilityLabel("Continue as guest button")
                    }
                    .milPadding(.horizontal, MILSpacing.screenPadding)
                    
                    // Privacy Info
                    MILCard(title: "Privacy & Security", subtitle: "Your data is protected") {
                        VStack(alignment: .leading, spacing: MILSpacing.sm) {
                            Text("• End-to-end encryption for all data")
                            Text("• Military-grade security standards")
                            Text("• No tracking or data selling")
                            Text("• You own your data")
                        }
                        .font(MILTypography.font(.caption))
                        .foregroundColor(MILColors.neutral6)
                    }
                    .milPadding(.horizontal, MILSpacing.screenPadding)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MILColors.neutral0.ignoresSafeArea())
        .sheet(isPresented: $showingEmailAuth) {
            EmailAuthView(
                onSignIn: { email, password in
                    Task {
                        await signInWithEmail(email: email, password: password)
                    }
                },
                onSignUp: { email, password, displayName in
                    Task {
                        await signUpWithEmail(email: email, password: password, displayName: displayName)
                    }
                }
            )
        }
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
    
    // MARK: - Auth Methods
    private func signInWithApple() async {
        viewModel.isLoading = true
        viewModel.errorMessage = nil
        
        do {
            let user = try await appEnvironment.authService.signInWithApple()
            await MainActor.run {
                appEnvironment.currentUser = user
                appEnvironment.isAuthenticated = true
                viewModel.continueFromAuth()
            }
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
        
        viewModel.isLoading = false
    }
    
    private func signInWithEmail(email: String, password: String) async {
        viewModel.isLoading = true
        viewModel.errorMessage = nil
        
        do {
            let user = try await appEnvironment.authService.signIn(email: email, password: password)
            await MainActor.run {
                appEnvironment.currentUser = user
                appEnvironment.isAuthenticated = true
                viewModel.continueFromAuth()
            }
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
        
        viewModel.isLoading = false
    }
    
    private func signUpWithEmail(email: String, password: String, displayName: String?) async {
        viewModel.isLoading = true
        viewModel.errorMessage = nil
        
        do {
            let user = try await appEnvironment.authService.signUp(email: email, password: password, displayName: displayName)
            await MainActor.run {
                appEnvironment.currentUser = user
                appEnvironment.isAuthenticated = true
                viewModel.continueFromAuth()
            }
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
        
        viewModel.isLoading = false
    }
    
    private func continueAsGuest() {
        // Create a guest user
        let guestUser = User(
            id: "guest-\(UUID().uuidString)",
            email: "guest@miltrack.app",
            displayName: "Guest User"
        )
        
        appEnvironment.currentUser = guestUser
        appEnvironment.isAuthenticated = true
        viewModel.continueFromAuth()
    }
}

struct EmailAuthView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var displayName = ""
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    let onSignIn: (String, String) -> Void
    let onSignUp: (String, String, String?) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: MILSpacing.xl) {
                // Header
                VStack(spacing: MILSpacing.md) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 50))
                        .foregroundColor(MILColors.accent)
                    
                    Text(isSignUp ? "Create Account" : "Sign In")
                        .font(MILTypography.font(.display2))
                        .foregroundColor(MILColors.neutral9)
                    
                    Text(isSignUp ? "Create your Miltrack account" : "Enter your credentials to continue")
                        .font(MILTypography.font(.body))
                        .foregroundColor(MILColors.neutral6)
                        .multilineTextAlignment(.center)
                }
                .milPadding(.top, MILSpacing.xl)
                
                // Form
                VStack(spacing: MILSpacing.lg) {
                    if isSignUp {
                        MILFormField(
                            title: "Display Name",
                            placeholder: "Enter your name",
                            value: $displayName
                        )
                    }
                    
                    MILFormField(
                        title: "Email",
                        placeholder: "Enter your email",
                        value: $email
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    
                    MILFormField(
                        title: "Password",
                        placeholder: "Enter your password",
                        style: .secure,
                        value: $password
                    )
                    
                    if isSignUp {
                        MILFormField(
                            title: "Confirm Password",
                            placeholder: "Confirm your password",
                            style: .secure,
                            value: $confirmPassword
                        )
                    }
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                
                Spacer()
                
                // Actions
                VStack(spacing: MILSpacing.md) {
                    MILButton(
                        isSignUp ? "Create Account" : "Sign In",
                        style: .primary
                    ) {
                        if isSignUp {
                            if password == confirmPassword {
                                onSignUp(email, password, displayName.isEmpty ? nil : displayName)
                                dismiss()
                            } else {
                                errorMessage = "Passwords do not match"
                                showingAlert = true
                            }
                        } else {
                            onSignIn(email, password)
                            dismiss()
                        }
                    }
                    .disabled(!isFormValid)
                    
                    MILButton(
                        isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up",
                        style: .ghost
                    ) {
                        isSignUp.toggle()
                    }
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.bottom, MILSpacing.xl)
            }
            .navigationTitle("Authentication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty && !password.isEmpty && !displayName.isEmpty && password == confirmPassword
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
}

struct AuthGateView_Previews: PreviewProvider {
    static var previews: some View {
        AuthGateView()
            .environment(\.appEnvironment, AppEnvironment.mock)
    }
}
