//
//  MainTabView.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.appEnvironment) private var appEnvironment
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "gauge")
                    Text("Dashboard")
                }
                .tag(0)
            
            FitnessHomeView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Fitness")
                }
                .tag(1)
            
            HealthHomeView()
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("Health")
                }
                .tag(2)
            
            ToolsHomeView()
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver")
                    Text("Tools")
                }
                .tag(3)
            
            AccountabilityHomeView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Accountability")
                }
                .tag(4)
            
            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("More")
                }
                .tag(5)
        }
        .accentColor(MILColors.brandPrimary)
        .background(MILColors.backgroundPrimary)
    }
}

#Preview {
    MainTabView()
        .environment(\.appEnvironment, AppEnvironment())
}
