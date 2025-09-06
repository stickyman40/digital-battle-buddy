//
//  FirebaseManager.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation

// Firebase imports are conditional - only import if available
#if canImport(FirebaseCore)
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseAnalytics
#endif

// MARK: - Firebase Manager
class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    @Published var isConfigured = false
    @Published var isInitialized = false
    
    private init() {
        checkConfiguration()
    }
    
    // MARK: - Configuration Check
    private func checkConfiguration() {
        // Check if GoogleService-Info.plist exists
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            Logger.auth("GoogleService-Info.plist not found. Running in mock mode.")
            isConfigured = false
            return
        }
        
        Logger.auth("GoogleService-Info.plist found at: \(path)")
        isConfigured = true
    }
    
    // MARK: - Firebase Initialization
    func initialize() async {
        guard isConfigured else {
            Logger.auth("Firebase not configured. Skipping initialization.")
            return
        }
        
        guard !isInitialized else {
            Logger.auth("Firebase already initialized.")
            return
        }
        
        #if canImport(FirebaseCore)
        do {
            // Configure Firebase
            FirebaseApp.configure()
            Logger.auth("Firebase configured successfully")
            
            // Initialize services
            await initializeServices()
            
            await MainActor.run {
                self.isInitialized = true
            }
            
            Logger.auth("Firebase initialization completed")
            
        } catch {
            Logger.error("Failed to initialize Firebase: \(error.localizedDescription)")
        }
        #else
        Logger.auth("Firebase SDK not available. Running in mock mode.")
        await MainActor.run {
            self.isInitialized = true
        }
        #endif
    }
    
    private func initializeServices() async {
        #if canImport(FirebaseCore)
        // Initialize Auth
        Auth.auth().useAppLanguage()
        Logger.auth("Firebase Auth initialized")
        
        // Initialize Firestore
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        Logger.database("Firestore initialized with persistence enabled")
        
        // Initialize Storage
        let storage = Storage.storage()
        Logger.database("Firebase Storage initialized")
        
        // Initialize Analytics
        Analytics.setAnalyticsCollectionEnabled(true)
        Logger.analytics("Firebase Analytics initialized")
        #endif
    }
    
    // MARK: - Service Getters
    #if canImport(FirebaseCore)
    var auth: Auth {
        return Auth.auth()
    }
    
    var firestore: Firestore {
        return Firestore.firestore()
    }
    
    var storage: Storage {
        return Storage.storage()
    }
    #endif
    
    // MARK: - Environment Detection
    var isProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
    
    var isMockMode: Bool {
        return !isConfigured
    }
}

// MARK: - Firebase Service Implementations
// These would be the real Firebase implementations that replace the mock services
// when Firebase is properly configured

#if canImport(FirebaseCore)
class FirebaseAuthService: AuthServiceProtocol {
    private let auth = FirebaseManager.shared.auth
    
    var currentUser: User? {
        guard let firebaseUser = auth.currentUser else { return nil }
        return convertFirebaseUser(firebaseUser)
    }
    
    var isAuthenticated: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) async throws -> User {
        Logger.auth("Firebase sign in attempt for email: \(email)")
        
        let result = try await auth.signIn(withEmail: email, password: password)
        let user = convertFirebaseUser(result.user)
        
        Logger.auth("Firebase sign in successful for user: \(user.id)")
        return user
    }
    
    func signUp(email: String, password: String, displayName: String?) async throws -> User {
        Logger.auth("Firebase sign up attempt for email: \(email)")
        
        let result = try await auth.createUser(withEmail: email, password: password)
        
        // Update display name if provided
        if let displayName = displayName {
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
        }
        
        let user = convertFirebaseUser(result.user)
        
        Logger.auth("Firebase sign up successful for user: \(user.id)")
        return user
    }
    
    func signInWithApple() async throws -> User {
        // This would implement Sign in with Apple
        // For now, throw an error indicating it's not implemented
        throw AuthError.unknown("Sign in with Apple not implemented yet")
    }
    
    func signOut() async throws {
        Logger.auth("Firebase sign out")
        
        try auth.signOut()
        
        Logger.auth("Firebase sign out successful")
    }
    
    func resetPassword(email: String) async throws {
        Logger.auth("Firebase password reset for email: \(email)")
        
        try await auth.sendPasswordReset(withEmail: email)
        
        Logger.auth("Password reset email sent to: \(email)")
    }
    
    func updateProfile(displayName: String?, branch: ServiceBranch?, rank: String?, unit: String?) async throws {
        Logger.auth("Firebase profile update")
        
        guard let firebaseUser = auth.currentUser else {
            throw AuthError.userNotFound
        }
        
        // Update Firebase Auth profile
        if let displayName = displayName {
            let changeRequest = firebaseUser.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()
        }
        
        // Update custom claims or Firestore document for branch, rank, unit
        // This would require additional Firestore operations
        
        Logger.auth("Firebase profile update successful")
    }
    
    func deleteAccount() async throws {
        Logger.auth("Firebase account deletion")
        
        guard let firebaseUser = auth.currentUser else {
            throw AuthError.userNotFound
        }
        
        try await firebaseUser.delete()
        
        Logger.auth("Firebase account deletion successful")
    }
    
    // MARK: - Helper Methods
    private func convertFirebaseUser(_ firebaseUser: FirebaseAuth.User) -> User {
        return User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            displayName: firebaseUser.displayName,
            branch: nil, // Would need to fetch from Firestore
            rank: nil,   // Would need to fetch from Firestore
            unit: nil,   // Would need to fetch from Firestore
            profileImageURL: firebaseUser.photoURL?.absoluteString,
            createdAt: firebaseUser.metadata.creationDate ?? Date(),
            updatedAt: firebaseUser.metadata.lastSignInDate ?? Date()
        )
    }
}
#endif
