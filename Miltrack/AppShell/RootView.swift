//
//  RootView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct RootView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var isOnboardingComplete = false
    
    var body: some View {
        Group {
            if isOnboardingComplete {
                MainTabView()
            } else {
                OnboardingIntroView()
            }
        }
        .background(MILColors.backgroundPrimary)
        .onAppear {
            checkOnboardingStatus()
        }
    }
    
    private func checkOnboardingStatus() {
        // For now, we'll skip onboarding and go straight to main app
        // In a real app, this would check UserDefaults or Firebase for onboarding completion
        isOnboardingComplete = true
    }
}

#Preview {
    RootView()
        .environment(\.appEnvironment, AppEnvironment())
}
