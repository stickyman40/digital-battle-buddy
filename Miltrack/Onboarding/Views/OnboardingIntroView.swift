//
//  OnboardingIntroView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct OnboardingIntroView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to Digital Battle Buddy",
            subtitle: "Your comprehensive fitness and health companion",
            image: "figure.run",
            description: "Track your PT tests, monitor your health, and stay accountable with your squad."
        ),
        OnboardingPage(
            title: "Fitness Tracking",
            subtitle: "Monitor your physical readiness",
            image: "heart.text.square",
            description: "Log workouts, track PT test scores, and monitor your body composition over time."
        ),
        OnboardingPage(
            title: "Health & Wellness",
            subtitle: "Take care of your mind and body",
            image: "brain.head.profile",
            description: "Track sleep, hydration, mental health check-ins, and overall wellness metrics."
        ),
        OnboardingPage(
            title: "Squad Accountability",
            subtitle: "Stay connected with your team",
            image: "person.3.fill",
            description: "Share progress with your squad, set goals together, and maintain accountability."
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Page Content
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
            // Bottom Section
            VStack(spacing: MILSpacing.lg) {
                // Page Indicators
                HStack(spacing: MILSpacing.sm) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? MILColors.brandPrimary : MILColors.neutral6)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                
                // Action Buttons
                VStack(spacing: MILSpacing.md) {
                    if currentPage == pages.count - 1 {
                        MILButton("Get Started", style: .primary, icon: "arrow.right") {
                            completeOnboarding()
                        }
                    } else {
                        HStack(spacing: MILSpacing.md) {
                            MILButton("Skip", style: .ghost) {
                                completeOnboarding()
                            }
                            
                            MILButton("Next", style: .primary, icon: "arrow.right") {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        }
                    }
                }
            }
            .milPadding(.horizontal, MILSpacing.screenPadding)
            .milPadding(.bottom, MILSpacing.xxxl)
        }
        .background(MILColors.backgroundPrimary)
    }
    
    private func completeOnboarding() {
        // In a real app, this would save onboarding completion to UserDefaults or Firebase
        withAnimation {
            // This would trigger navigation to main app
            print("Onboarding completed")
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: MILSpacing.xxxl) {
            Spacer()
            
            // Image
            Image(systemName: page.image)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(MILColors.brandPrimary)
                .milPadding(.bottom, MILSpacing.lg)
            
            // Content
            VStack(spacing: MILSpacing.lg) {
                VStack(spacing: MILSpacing.sm) {
                    Text(page.title)
                        .milTypography(.display2, weight: .bold)
                        .foregroundColor(MILColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(page.subtitle)
                        .milTypography(.title3, weight: .medium)
                        .foregroundColor(MILColors.brandPrimary)
                        .multilineTextAlignment(.center)
                }
                
                Text(page.description)
                    .milTypography(.body)
                    .foregroundColor(MILColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .milPadding(.horizontal, MILSpacing.xl)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingIntroView()
        .environment(\.appEnvironment, AppEnvironment())
}
