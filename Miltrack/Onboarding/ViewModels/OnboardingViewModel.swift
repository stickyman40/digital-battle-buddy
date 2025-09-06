//
//  OnboardingViewModel.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentState: OnboardingState = .intro
    @Published var currentSlideIndex = 0
    @Published var permissions: [Permission] = []
    @Published var profileData = ProfileSetupData()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Onboarding slides
    let slides: [OnboardingSlide] = [
        OnboardingSlide(
            id: "mission",
            title: "Your Mission",
            subtitle: "Track Everything",
            description: "Monitor your fitness, health, and readiness with military precision. Stay mission-ready with comprehensive tracking tools.",
            systemImage: "target",
            primaryColor: "brandPrimary"
        ),
        OnboardingSlide(
            id: "all-in-one",
            title: "All-in-One",
            subtitle: "Complete Solution",
            description: "From PT tests to sleep tracking, accountability to tools - everything you need in one secure platform.",
            systemImage: "square.grid.3x3.fill",
            primaryColor: "brandSecondary"
        ),
        OnboardingSlide(
            id: "secure",
            title: "Secure & Private",
            subtitle: "Your Data, Protected",
            description: "Military-grade security with end-to-end encryption. Your data stays private and secure, always.",
            systemImage: "lock.shield.fill",
            primaryColor: "accent"
        )
    ]
    
    init() {
        setupPermissions()
    }
    
    private func setupPermissions() {
        permissions = [
            Permission(
                id: "notifications",
                title: "Notifications",
                description: "Get reminders for PT tests, health check-ins, and important updates.",
                systemImage: "bell.fill",
                isGranted: false,
                isRequired: false
            ),
            Permission(
                id: "healthkit",
                title: "Health Data",
                description: "Sync with Apple Health to track sleep, heart rate, and fitness metrics.",
                systemImage: "heart.fill",
                isGranted: false,
                isRequired: false
            )
        ]
    }
    
    // MARK: - Navigation
    func nextSlide() {
        if currentSlideIndex < slides.count - 1 {
            currentSlideIndex += 1
        } else {
            currentState = .permissions
        }
    }
    
    func previousSlide() {
        if currentSlideIndex > 0 {
            currentSlideIndex -= 1
        }
    }
    
    func skipToPermissions() {
        currentState = .permissions
    }
    
    func continueFromPermissions() {
        currentState = .auth
    }
    
    func continueFromAuth() {
        currentState = .profileSetup
    }
    
    func completeOnboarding() {
        currentState = .complete
    }
    
    // MARK: - Permissions
    func togglePermission(_ permissionId: String) {
        if let index = permissions.firstIndex(where: { $0.id == permissionId }) {
            permissions[index].isGranted.toggle()
        }
    }
    
    func requestPermissions() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate permission requests
        for permission in permissions {
            if permission.isGranted {
                // In a real app, you would request actual permissions here
                Logger.auth("Requesting permission: \(permission.title)")
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Profile Setup
    func updateBranch(_ branch: ServiceBranch) {
        profileData.branch = branch
    }
    
    func updateRank(_ rank: String) {
        profileData.rank = rank
    }
    
    func updateUnit(_ unit: String) {
        profileData.unit = unit
    }
    
    func saveProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulate saving profile data
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // In a real app, you would save to Firestore here
            Logger.auth("Profile saved: \(profileData)")
            
            completeOnboarding()
        } catch {
            errorMessage = "Failed to save profile. Please try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Computed Properties
    var currentSlide: OnboardingSlide {
        slides[currentSlideIndex]
    }
    
    var canProceedFromPermissions: Bool {
        // All required permissions are granted, or user can skip optional ones
        let requiredPermissions = permissions.filter { $0.isRequired }
        return requiredPermissions.allSatisfy { $0.isGranted }
    }
    
    var canProceedFromProfile: Bool {
        profileData.isComplete
    }
    
    var progressPercentage: Double {
        switch currentState {
        case .intro:
            return Double(currentSlideIndex) / Double(slides.count)
        case .permissions:
            return 0.4
        case .auth:
            return 0.6
        case .profileSetup:
            return 0.8
        case .complete:
            return 1.0
        }
    }
}
