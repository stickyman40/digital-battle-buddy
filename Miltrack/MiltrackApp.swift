//
//  MiltrackApp.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

@main
struct MiltrackApp: App {
    @StateObject private var appEnvironment = AppEnvironment()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.appEnvironment, appEnvironment)
                .onAppear {
                    Task {
                        await FirebaseManager.shared.initialize()
                    }
                }
        }
    }
}
