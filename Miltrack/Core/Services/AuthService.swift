//
//  AuthService.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation
import Combine

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }
    
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, displayName: String?) async throws -> User
    func signInWithApple() async throws -> User
    func signOut() async throws
    func resetPassword(email: String) async throws
    func updateProfile(displayName: String?, branch: ServiceBranch?, rank: String?, unit: String?) async throws
    func deleteAccount() async throws
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case userNotFound
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyInUse:
            return "An account with this email already exists"
        case .weakPassword:
            return "Password must be at least 8 characters long"
        case .userNotFound:
            return "No account found with this email"
        case .networkError:
            return "Network error. Please check your connection"
        case .unknown(let message):
            return message
        }
    }
}

// MARK: - Mock Auth Service
class MockAuthService: AuthServiceProtocol {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    init() {
        // Simulate checking for existing session
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Uncomment to simulate logged in state
            // self.currentUser = User(id: "mock-user", email: "test@example.com", displayName: "Test User")
            // self.isAuthenticated = true
        }
    }
    
    func signIn(email: String, password: String) async throws -> User {
        Logger.auth("Mock sign in attempt for email: \(email)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Mock validation
        guard email.isValidEmail else {
            throw AuthError.invalidCredentials
        }
        
        guard password.isValidPassword else {
            throw AuthError.invalidCredentials
        }
        
        // Mock successful sign in
        let user = User(
            id: "mock-user-\(UUID().uuidString)",
            email: email,
            displayName: "Mock User",
            branch: .army,
            rank: "E-4",
            unit: "1st Battalion"
        )
        
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }
        
        return user
    }
    
    func signUp(email: String, password: String, displayName: String?) async throws -> User {
        Logger.auth("Mock sign up attempt for email: \(email)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Mock validation
        guard email.isValidEmail else {
            throw AuthError.invalidCredentials
        }
        
        guard password.isValidPassword else {
            throw AuthError.weakPassword
        }
        
        // Mock successful sign up
        let user = User(
            id: "mock-user-\(UUID().uuidString)",
            email: email,
            displayName: displayName ?? "New User",
            branch: nil,
            rank: nil,
            unit: nil
        )
        
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }
        
        return user
    }
    
    func signInWithApple() async throws -> User {
        Logger.auth("Mock Apple sign in attempt")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Mock successful Apple sign in
        let user = User(
            id: "apple-user-\(UUID().uuidString)",
            email: "user@privaterelay.appleid.com",
            displayName: "Apple User",
            branch: nil,
            rank: nil,
            unit: nil
        )
        
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }
        
        return user
    }
    
    func signOut() async throws {
        Logger.auth("Mock sign out")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        await MainActor.run {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
    
    func resetPassword(email: String) async throws {
        Logger.auth("Mock password reset for email: \(email)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        guard email.isValidEmail else {
            throw AuthError.userNotFound
        }
        
        // Mock successful password reset
        Logger.auth("Password reset email sent to: \(email)")
    }
    
    func updateProfile(displayName: String?, branch: ServiceBranch?, rank: String?, unit: String?) async throws {
        Logger.auth("Mock profile update")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        guard let currentUser = currentUser else {
            throw AuthError.userNotFound
        }
        
        let updatedUser = User(
            id: currentUser.id,
            email: currentUser.email,
            displayName: displayName ?? currentUser.displayName,
            branch: branch ?? currentUser.branch,
            rank: rank ?? currentUser.rank,
            unit: unit ?? currentUser.unit,
            profileImageURL: currentUser.profileImageURL,
            createdAt: currentUser.createdAt,
            updatedAt: Date()
        )
        
        await MainActor.run {
            self.currentUser = updatedUser
        }
    }
    
    func deleteAccount() async throws {
        Logger.auth("Mock account deletion")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        await MainActor.run {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
}
