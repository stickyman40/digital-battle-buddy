//
//  AppRouter.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

// MARK: - App Router
@MainActor
class AppRouter: ObservableObject {
    @Published var currentRoute: AppRoute = .dashboard
    @Published var navigationPath = NavigationPath()
    @Published var onboardingState: OnboardingState = .intro
    
    enum AppRoute: Hashable {
        case dashboard
        case fitness
        case health
        case tools
        case accountability
        case more
        case profile
        case settings
        case onboarding
    }
    
    // MARK: - Navigation Methods
    func navigate(to route: AppRoute) {
        currentRoute = route
        navigationPath.append(route)
    }
    
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
        currentRoute = .dashboard
    }
    
    // MARK: - Onboarding Navigation
    func nextOnboardingStep() {
        switch onboardingState {
        case .intro:
            onboardingState = .permissions
        case .permissions:
            onboardingState = .auth
        case .auth:
            onboardingState = .profileSetup
        case .profileSetup:
            onboardingState = .complete
        case .complete:
            break
        }
    }
    
    func previousOnboardingStep() {
        switch onboardingState {
        case .intro:
            break
        case .permissions:
            onboardingState = .intro
        case .auth:
            onboardingState = .permissions
        case .profileSetup:
            onboardingState = .auth
        case .complete:
            onboardingState = .profileSetup
        }
    }
    
    func skipToAuth() {
        onboardingState = .auth
    }
    
    func skipToProfileSetup() {
        onboardingState = .profileSetup
    }
    
    func completeOnboarding() {
        onboardingState = .complete
    }
    
    // MARK: - Computed Properties
    var shouldShowOnboarding: Bool {
        return onboardingState != .complete
    }
    
    var currentOnboardingView: some View {
        Group {
            switch onboardingState {
            case .intro:
                OnboardingIntroView()
            case .permissions:
                PermissionsView()
            case .auth:
                AuthGateView()
            case .profileSetup:
                ProfileSetupView()
            case .complete:
                MainTabView()
            }
        }
    }
}

// MARK: - Route Extensions
extension AppRouter.AppRoute {
    var title: String {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .fitness:
            return "Fitness"
        case .health:
            return "Health"
        case .tools:
            return "Tools"
        case .accountability:
            return "Accountability"
        case .more:
            return "More"
        case .profile:
            return "Profile"
        case .settings:
            return "Settings"
        case .onboarding:
            return "Welcome"
        }
    }
    
    var tabIndex: Int? {
        switch self {
        case .dashboard:
            return 0
        case .fitness:
            return 1
        case .health:
            return 2
        case .tools:
            return 3
        case .accountability:
            return 4
        case .more:
            return 5
        default:
            return nil
        }
    }
}