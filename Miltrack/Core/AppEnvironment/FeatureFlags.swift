//
//  FeatureFlags.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation

struct FeatureFlags {
    // MARK: - Feature Toggles
    let enableFirebase: Bool
    let enableAnalytics: Bool
    let enableCrashlytics: Bool
    let enableHealthKit: Bool
    let enableNotifications: Bool
    let enableDarkMode: Bool
    let enableOfflineMode: Bool
    
    // MARK: - UI Features
    let enableAdvancedFitness: Bool
    let enableSocialFeatures: Bool
    let enableGamification: Bool
    let enableCustomThemes: Bool
    
    // MARK: - Development Features
    let enableDebugMenu: Bool
    let enableMockData: Bool
    let enablePerformanceMonitoring: Bool
    
    init() {
        // Check if Firebase is configured
        let hasFirebaseConfig = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil
        
        // Core features
        self.enableFirebase = hasFirebaseConfig
        self.enableAnalytics = hasFirebaseConfig
        self.enableCrashlytics = hasFirebaseConfig
        self.enableHealthKit = true
        self.enableNotifications = true
        self.enableDarkMode = true
        self.enableOfflineMode = true
        
        // UI features
        self.enableAdvancedFitness = true
        self.enableSocialFeatures = false // Disabled for initial release
        self.enableGamification = false // Disabled for initial release
        self.enableCustomThemes = false // Disabled for initial release
        
        // Development features
        #if DEBUG
        self.enableDebugMenu = true
        self.enableMockData = !hasFirebaseConfig
        self.enablePerformanceMonitoring = true
        #else
        self.enableDebugMenu = false
        self.enableMockData = false
        self.enablePerformanceMonitoring = false
        #endif
    }
    
    // MARK: - Convenience Methods
    var isFirebaseEnabled: Bool {
        return enableFirebase
    }
    
    var isMockMode: Bool {
        return enableMockData
    }
    
    var isDebugMode: Bool {
        return enableDebugMenu
    }
}
