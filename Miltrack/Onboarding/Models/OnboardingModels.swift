//
//  OnboardingModels.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation

// MARK: - Onboarding Slide
struct OnboardingSlide {
    let id: String
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
    let primaryColor: String
}

// MARK: - Permission
struct Permission {
    let id: String
    let title: String
    let description: String
    let systemImage: String
    var isGranted: Bool
    let isRequired: Bool
}

// MARK: - Profile Setup Data
struct ProfileSetupData {
    var branch: ServiceBranch?
    var rank: String?
    var unit: String?
    
    var isComplete: Bool {
        return branch != nil && rank != nil && !(unit?.isEmpty ?? true)
    }
}

// MARK: - Rank Enum
enum MilitaryRank: String, CaseIterable, Codable {
    case e1 = "E-1"
    case e2 = "E-2"
    case e3 = "E-3"
    case e4 = "E-4"
    case e5 = "E-5"
    case e6 = "E-6"
    case e7 = "E-7"
    case e8 = "E-8"
    case e9 = "E-9"
    case o1 = "O-1"
    case o2 = "O-2"
    case o3 = "O-3"
    case o4 = "O-4"
    case o5 = "O-5"
    case o6 = "O-6"
    case o7 = "O-7"
    case o8 = "O-8"
    case o9 = "O-9"
    case w1 = "W-1"
    case w2 = "W-2"
    case w3 = "W-3"
    case w4 = "W-4"
    case w5 = "W-5"
    
    var displayName: String {
        switch self {
        case .e1: return "E-1 (Private)"
        case .e2: return "E-2 (Private First Class)"
        case .e3: return "E-3 (Lance Corporal)"
        case .e4: return "E-4 (Corporal)"
        case .e5: return "E-5 (Sergeant)"
        case .e6: return "E-6 (Staff Sergeant)"
        case .e7: return "E-7 (Sergeant First Class)"
        case .e8: return "E-8 (Master Sergeant)"
        case .e9: return "E-9 (Sergeant Major)"
        case .o1: return "O-1 (Second Lieutenant)"
        case .o2: return "O-2 (First Lieutenant)"
        case .o3: return "O-3 (Captain)"
        case .o4: return "O-4 (Major)"
        case .o5: return "O-5 (Lieutenant Colonel)"
        case .o6: return "O-6 (Colonel)"
        case .o7: return "O-7 (Brigadier General)"
        case .o8: return "O-8 (Major General)"
        case .o9: return "O-9 (Lieutenant General)"
        case .w1: return "W-1 (Warrant Officer 1)"
        case .w2: return "W-2 (Chief Warrant Officer 2)"
        case .w3: return "W-3 (Chief Warrant Officer 3)"
        case .w4: return "W-4 (Chief Warrant Officer 4)"
        case .w5: return "W-5 (Chief Warrant Officer 5)"
        }
    }
}

// MARK: - Onboarding State
enum OnboardingState {
    case intro
    case permissions
    case auth
    case profileSetup
    case complete
}
