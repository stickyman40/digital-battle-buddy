//
//  AppEnvironment.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI
import Combine

// MARK: - App Environment
class AppEnvironment: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Services
    let authService: AuthServiceProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    
    // Feature Flags
    let featureFlags: FeatureFlags
    
    init(
        authService: AuthServiceProtocol? = nil,
        firestoreService: FirestoreServiceProtocol? = nil,
        storageService: StorageServiceProtocol? = nil,
        featureFlags: FeatureFlags = FeatureFlags()
    ) {
        self.featureFlags = featureFlags
        
        // Choose services based on feature flags and Firebase availability
        if featureFlags.enableMockData || FirebaseManager.shared.isMockMode {
            self.authService = authService ?? MockAuthService()
            self.firestoreService = firestoreService ?? MockFirestoreService()
            self.storageService = storageService ?? MockStorageService()
        } else {
            // Use Firebase services if available
            #if canImport(FirebaseCore)
            self.authService = authService ?? FirebaseAuthService()
            self.firestoreService = firestoreService ?? FirebaseFirestoreService()
            self.storageService = storageService ?? FirebaseStorageService()
            #else
            self.authService = authService ?? MockAuthService()
            self.firestoreService = firestoreService ?? MockFirestoreService()
            self.storageService = storageService ?? MockStorageService()
            #endif
        }
    }
    
    // MARK: - Authentication
    @MainActor
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.signIn(email: email, password: password)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func signOut() async {
        isLoading = true
        
        do {
            try await authService.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Convenience Methods
    static var mock: AppEnvironment {
        // Create a custom FeatureFlags that forces mock mode
        let featureFlags = FeatureFlags()
        return AppEnvironment(featureFlags: featureFlags)
    }
    
    static var firebase: AppEnvironment {
        // Create a custom FeatureFlags that forces Firebase mode
        // This would require modifying FeatureFlags to support custom initialization
        // For now, we'll use the default which will choose based on Firebase availability
        return AppEnvironment()
    }
}

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: String
    let email: String
    let displayName: String?
    let branch: ServiceBranch?
    let rank: String?
    let unit: String?
    let profileImageURL: String?
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: String,
        email: String,
        displayName: String? = nil,
        branch: ServiceBranch? = nil,
        rank: String? = nil,
        unit: String? = nil,
        profileImageURL: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.branch = branch
        self.rank = rank
        self.unit = unit
        self.profileImageURL = profileImageURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Service Branch
enum ServiceBranch: String, CaseIterable, Codable {
    case army = "Army"
    case navy = "Navy"
    case airForce = "Air Force"
    case marines = "Marines"
    case spaceForce = "Space Force"
    case coastGuard = "Coast Guard"
    
    var abbreviation: String {
        switch self {
        case .army: return "USA"
        case .navy: return "USN"
        case .airForce: return "USAF"
        case .marines: return "USMC"
        case .spaceForce: return "USSF"
        case .coastGuard: return "USCG"
        }
    }
}

// MARK: - Environment Key
private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue = AppEnvironment()
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
