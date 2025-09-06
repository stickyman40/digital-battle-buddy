//
//  RootView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct RootView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @StateObject private var appRouter = AppRouter()
    
    var body: some View {
        Group {
            if appEnvironment.isAuthenticated {
                MainTabView()
            } else {
                appRouter.currentOnboardingView
            }
        }
        .background(MILColors.neutral0.ignoresSafeArea())
        .environmentObject(appRouter)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environment(\.appEnvironment, AppEnvironment.mock)
    }
}