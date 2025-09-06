//
//  OnboardingIntroView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct OnboardingIntroView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.appEnvironment) private var appEnvironment
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            ProgressView(value: viewModel.progressPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: MILColors.accent))
                .milPadding(.horizontal, MILSpacing.screenPadding)
                .milPadding(.top, MILSpacing.md)
            
            // Slide Content
            TabView(selection: $viewModel.currentSlideIndex) {
                ForEach(Array(viewModel.slides.enumerated()), id: \.element.id) { index, slide in
                    OnboardingSlideView(slide: slide)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentSlideIndex)
            
            // Navigation Controls
            VStack(spacing: MILSpacing.lg) {
                // Page Indicators
                HStack(spacing: MILSpacing.md) {
                    ForEach(0..<viewModel.slides.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentSlideIndex ? MILColors.accent : MILColors.neutral6)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: viewModel.currentSlideIndex)
                    }
                }
                .milPadding(.bottom, MILSpacing.md)
                
                // Action Buttons
                HStack(spacing: MILSpacing.lg) {
                    if viewModel.currentSlideIndex > 0 {
                        MILButton("Back", style: .ghost) {
                            viewModel.previousSlide()
                        }
                        .accessibilityLabel("Back button")
                    } else {
                        Spacer()
                    }
                    
                    MILButton(
                        viewModel.currentSlideIndex == viewModel.slides.count - 1 ? "Continue" : "Next",
                        style: .primary
                    ) {
                        viewModel.nextSlide()
                    }
                    .accessibilityLabel("Next button")
                }
                .milPadding(.horizontal, MILSpacing.screenPadding)
            }
            .milPadding(.bottom, MILSpacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MILColors.neutral0.ignoresSafeArea())
        .onChange(of: viewModel.currentState) { _, newState in
            if newState == .permissions {
                // Navigate to permissions view
                // This will be handled by the parent router
            }
        }
    }
}

struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    
    var body: some View {
        VStack(spacing: MILSpacing.xxl) {
            Spacer()
            
            // Icon
            Image(systemName: slide.systemImage)
                .font(.system(size: 80))
                .foregroundColor(Color(slide.primaryColor))
                .milPadding(.bottom, MILSpacing.xl)
            
            // Title
            Text(slide.title)
                .font(MILTypography.font(.display1))
                .foregroundColor(MILColors.neutral9)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text(slide.subtitle)
                .font(MILTypography.font(.title2))
                .foregroundColor(MILColors.accent)
                .multilineTextAlignment(.center)
            
            // Description
            Text(slide.description)
                .font(MILTypography.font(.body))
                .foregroundColor(MILColors.neutral6)
                .multilineTextAlignment(.center)
                .milPadding(.horizontal, MILSpacing.xl)
            
            Spacer()
        }
        .milPadding(.horizontal, MILSpacing.screenPadding)
    }
}

struct OnboardingIntroView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIntroView()
            .environment(\.appEnvironment, AppEnvironment.mock)
    }
}