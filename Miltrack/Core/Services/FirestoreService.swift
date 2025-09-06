//
//  FirestoreService.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation
import Combine

// Firebase imports are conditional - only import if available
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

// MARK: - Firestore Service Protocol
protocol FirestoreServiceProtocol {
    // Generic CRUD operations
    func create<T: Codable>(_ document: T, in collection: String) async throws -> String
    func read<T: Codable>(_ type: T.Type, from collection: String, documentId: String) async throws -> T?
    func update<T: Codable>(_ document: T, in collection: String, documentId: String) async throws
    func delete(from collection: String, documentId: String) async throws
    
    // Query operations
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isEqualTo value: Any) async throws -> [T]
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isGreaterThan value: Any) async throws -> [T]
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isLessThan value: Any) async throws -> [T]
    func query<T: Codable>(_ type: T.Type, from collection: String, orderBy field: String, descending: Bool, limit: Int?) async throws -> [T]
    
    // Real-time listeners
    func listen<T: Codable>(_ type: T.Type, from collection: String, documentId: String) -> AnyPublisher<T?, Never>
    func listen<T: Codable>(_ type: T.Type, from collection: String, where field: String, isEqualTo value: Any) -> AnyPublisher<[T], Never>
}

// MARK: - Firestore Errors
enum FirestoreError: LocalizedError {
    case documentNotFound
    case invalidData
    case networkError
    case permissionDenied
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .documentNotFound:
            return "Document not found"
        case .invalidData:
            return "Invalid data format"
        case .networkError:
            return "Network error. Please check your connection"
        case .permissionDenied:
            return "Permission denied"
        case .unknown(let message):
            return message
        }
    }
}

// MARK: - Mock Firestore Service
class MockFirestoreService: FirestoreServiceProtocol {
    private var mockData: [String: [String: Any]] = [:]
    private var listeners: [String: Any] = [:]
    
    init() {
        setupMockData()
    }
    
    private func setupMockData() {
        // Mock user data
        mockData["users"] = [
            "mock-user": [
                "id": "mock-user",
                "email": "test@example.com",
                "displayName": "Test User",
                "branch": "Army",
                "rank": "E-4",
                "unit": "1st Battalion",
                "createdAt": Date().timeIntervalSince1970,
                "updatedAt": Date().timeIntervalSince1970
            ]
        ]
        
        // Mock fitness data
        mockData["fitness"] = [
            "workout-1": [
                "id": "workout-1",
                "userId": "mock-user",
                "type": "PT Test",
                "date": Date().timeIntervalSince1970,
                "score": 85,
                "notes": "Great performance today!"
            ]
        ]
    }
    
    func create<T: Codable>(_ document: T, in collection: String) async throws -> String {
        Logger.database("Mock create document in collection: \(collection)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        let documentId = UUID().uuidString
        
        // Convert to dictionary (simplified)
        if let data = try? JSONEncoder().encode(document),
           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            
            if mockData[collection] == nil {
                mockData[collection] = [:]
            }
            mockData[collection]?[documentId] = dict
            
            Logger.database("Created document \(documentId) in collection \(collection)")
            return documentId
        } else {
            throw FirestoreError.invalidData
        }
    }
    
    func read<T: Codable>(_ type: T.Type, from collection: String, documentId: String) async throws -> T? {
        Logger.database("Mock read document \(documentId) from collection: \(collection)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        guard let collectionData = mockData[collection],
              let documentData = collectionData[documentId] else {
            return nil
        }
        
        // Convert back to object (simplified)
        if let data = try? JSONSerialization.data(withJSONObject: documentData),
           let object = try? JSONDecoder().decode(type, from: data) {
            return object
        } else {
            throw FirestoreError.invalidData
        }
    }
    
    func update<T: Codable>(_ document: T, in collection: String, documentId: String) async throws {
        Logger.database("Mock update document \(documentId) in collection: \(collection)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        guard mockData[collection]?[documentId] != nil else {
            throw FirestoreError.documentNotFound
        }
        
        // Convert to dictionary and update
        if let data = try? JSONEncoder().encode(document),
           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            mockData[collection]?[documentId] = dict
            Logger.database("Updated document \(documentId) in collection \(collection)")
        } else {
            throw FirestoreError.invalidData
        }
    }
    
    func delete(from collection: String, documentId: String) async throws {
        Logger.database("Mock delete document \(documentId) from collection: \(collection)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        guard mockData[collection]?[documentId] != nil else {
            throw FirestoreError.documentNotFound
        }
        
        mockData[collection]?.removeValue(forKey: documentId)
        Logger.database("Deleted document \(documentId) from collection \(collection)")
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isEqualTo value: Any) async throws -> [T] {
        Logger.database("Mock query collection: \(collection) where \(field) == \(value)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4 seconds
        
        guard let collectionData = mockData[collection] else {
            return []
        }
        
        var results: [T] = []
        
        for (_, documentData) in collectionData {
            if let documentDict = documentData as? [String: Any],
               let fieldValue = documentDict[field] as? AnyHashable,
               let queryValue = value as? AnyHashable,
               fieldValue == queryValue {
                
                if let data = try? JSONSerialization.data(withJSONObject: documentData),
                   let object = try? JSONDecoder().decode(type, from: data) {
                    results.append(object)
                }
            }
        }
        
        return results
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isGreaterThan value: Any) async throws -> [T] {
        // Simplified implementation for mock
        return try await query(type, from: collection, where: field, isEqualTo: value)
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isLessThan value: Any) async throws -> [T] {
        // Simplified implementation for mock
        return try await query(type, from: collection, where: field, isEqualTo: value)
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, orderBy field: String, descending: Bool, limit: Int?) async throws -> [T] {
        Logger.database("Mock query collection: \(collection) order by \(field)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4 seconds
        
        let results = try await query(type, from: collection, where: field, isEqualTo: "")
        
        // Apply limit if specified
        if let limit = limit {
            return Array(results.prefix(limit))
        }
        
        return results
    }
    
    func listen<T: Codable>(_ type: T.Type, from collection: String, documentId: String) -> AnyPublisher<T?, Never> {
        let subject = PassthroughSubject<T?, Never>()
        let key = "\(collection)/\(documentId)"
        listeners[key] = subject
        
        // Simulate real-time updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task {
                do {
                    let result = try await self.read(type, from: collection, documentId: documentId)
                    subject.send(result)
                } catch {
                    subject.send(nil)
                }
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func listen<T: Codable>(_ type: T.Type, from collection: String, where field: String, isEqualTo value: Any) -> AnyPublisher<[T], Never> {
        let subject = PassthroughSubject<[T], Never>()
        let key = "\(collection)/\(field)/\(value)"
        listeners[key] = subject
        
        // Simulate real-time updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task {
                do {
                    let results = try await self.query(type, from: collection, where: field, isEqualTo: value)
                    subject.send(results)
                } catch {
                    subject.send([])
                }
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - Firebase Firestore Service
#if canImport(FirebaseFirestore)
class FirebaseFirestoreService: FirestoreServiceProtocol {
    private let db = FirebaseManager.shared.firestore
    private var listeners: [String: ListenerRegistration] = [:]
    
    func create<T: Codable>(_ document: T, in collection: String) async throws -> String {
        Logger.database("Firebase create document in collection: \(collection)")
        
        let docRef = db.collection(collection).document()
        
        do {
            try docRef.setData(from: document)
            Logger.database("Created document \(docRef.documentID) in collection \(collection)")
            return docRef.documentID
        } catch {
            Logger.error("Failed to create document: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func read<T: Codable>(_ type: T.Type, from collection: String, documentId: String) async throws -> T? {
        Logger.database("Firebase read document \(documentId) from collection: \(collection)")
        
        let docRef = db.collection(collection).document(documentId)
        
        do {
            let document = try await docRef.getDocument()
            guard document.exists else {
                return nil
            }
            
            let result = try document.data(as: type)
            return result
        } catch {
            Logger.error("Failed to read document: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func update<T: Codable>(_ document: T, in collection: String, documentId: String) async throws {
        Logger.database("Firebase update document \(documentId) in collection: \(collection)")
        
        let docRef = db.collection(collection).document(documentId)
        
        do {
            try docRef.setData(from: document, merge: true)
            Logger.database("Updated document \(documentId) in collection \(collection)")
        } catch {
            Logger.error("Failed to update document: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func delete(from collection: String, documentId: String) async throws {
        Logger.database("Firebase delete document \(documentId) from collection: \(collection)")
        
        let docRef = db.collection(collection).document(documentId)
        
        do {
            try await docRef.delete()
            Logger.database("Deleted document \(documentId) from collection \(collection)")
        } catch {
            Logger.error("Failed to delete document: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isEqualTo value: Any) async throws -> [T] {
        Logger.database("Firebase query collection: \(collection) where \(field) == \(value)")
        
        do {
            let querySnapshot = try await db.collection(collection)
                .whereField(field, isEqualTo: value)
                .getDocuments()
            
            let results = try querySnapshot.documents.compactMap { document in
                try document.data(as: type)
            }
            
            return results
        } catch {
            Logger.error("Failed to query documents: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isGreaterThan value: Any) async throws -> [T] {
        Logger.database("Firebase query collection: \(collection) where \(field) > \(value)")
        
        do {
            let querySnapshot = try await db.collection(collection)
                .whereField(field, isGreaterThan: value)
                .getDocuments()
            
            let results = try querySnapshot.documents.compactMap { document in
                try document.data(as: type)
            }
            
            return results
        } catch {
            Logger.error("Failed to query documents: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, where field: String, isLessThan value: Any) async throws -> [T] {
        Logger.database("Firebase query collection: \(collection) where \(field) < \(value)")
        
        do {
            let querySnapshot = try await db.collection(collection)
                .whereField(field, isLessThan: value)
                .getDocuments()
            
            let results = try querySnapshot.documents.compactMap { document in
                try document.data(as: type)
            }
            
            return results
        } catch {
            Logger.error("Failed to query documents: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func query<T: Codable>(_ type: T.Type, from collection: String, orderBy field: String, descending: Bool, limit: Int?) async throws -> [T] {
        Logger.database("Firebase query collection: \(collection) order by \(field)")
        
        do {
            var query = db.collection(collection).order(by: field, descending: descending)
            
            if let limit = limit {
                query = query.limit(to: limit)
            }
            
            let querySnapshot = try await query.getDocuments()
            
            let results = try querySnapshot.documents.compactMap { document in
                try document.data(as: type)
            }
            
            return results
        } catch {
            Logger.error("Failed to query documents: \(error.localizedDescription)")
            throw FirestoreError.unknown(error.localizedDescription)
        }
    }
    
    func listen<T: Codable>(_ type: T.Type, from collection: String, documentId: String) -> AnyPublisher<T?, Never> {
        let subject = PassthroughSubject<T?, Never>()
        let key = "\(collection)/\(documentId)"
        
        let listener = db.collection(collection).document(documentId)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    Logger.error("Firebase listener error: \(error.localizedDescription)")
                    subject.send(nil)
                    return
                }
                
                guard let document = documentSnapshot else {
                    subject.send(nil)
                    return
                }
                
                do {
                    let result = try document.data(as: type)
                    subject.send(result)
                } catch {
                    Logger.error("Failed to decode document: \(error.localizedDescription)")
                    subject.send(nil)
                }
            }
        
        listeners[key] = listener
        
        return subject.eraseToAnyPublisher()
    }
    
    func listen<T: Codable>(_ type: T.Type, from collection: String, where field: String, isEqualTo value: Any) -> AnyPublisher<[T], Never> {
        let subject = PassthroughSubject<[T], Never>()
        let key = "\(collection)/\(field)/\(value)"
        
        let listener = db.collection(collection)
            .whereField(field, isEqualTo: value)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    Logger.error("Firebase listener error: \(error.localizedDescription)")
                    subject.send([])
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    subject.send([])
                    return
                }
                
                let results = documents.compactMap { document in
                    try? document.data(as: type)
                }
                
                subject.send(results)
            }
        
        listeners[key] = listener
        
        return subject.eraseToAnyPublisher()
    }
    
    deinit {
        // Clean up listeners
        for (_, listener) in listeners {
            listener.remove()
        }
    }
}
#endif
