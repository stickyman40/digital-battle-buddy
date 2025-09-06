//
//  StorageService.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation
import UIKit
import Combine

// Firebase imports are conditional - only import if available
#if canImport(FirebaseStorage)
import FirebaseStorage
#endif

// MARK: - Storage Service Protocol
protocol StorageServiceProtocol {
    func uploadImage(_ image: UIImage, to path: String) async throws -> String
    func uploadData(_ data: Data, to path: String) async throws -> String
    func downloadImage(from path: String) async throws -> UIImage
    func downloadData(from path: String) async throws -> Data
    func deleteFile(at path: String) async throws
    func getDownloadURL(for path: String) async throws -> URL
}

// MARK: - Storage Errors
enum StorageError: LocalizedError {
    case fileNotFound
    case uploadFailed
    case downloadFailed
    case invalidImage
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .uploadFailed:
            return "Failed to upload file"
        case .downloadFailed:
            return "Failed to download file"
        case .invalidImage:
            return "Invalid image format"
        case .networkError:
            return "Network error. Please check your connection"
        case .unknown(let message):
            return message
        }
    }
}

// MARK: - Mock Storage Service
class MockStorageService: StorageServiceProtocol {
    private var mockFiles: [String: Data] = [:]
    private var mockImages: [String: UIImage] = [:]
    
    init() {
        setupMockData()
    }
    
    private func setupMockData() {
        // Create a mock profile image
        if let mockImage = createMockImage() {
            mockImages["profile-images/mock-user.jpg"] = mockImage
        }
    }
    
    private func createMockImage() -> UIImage? {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // Create a gradient background
            let colors = [MILColors.brandPrimary.cgColor, MILColors.brandSecondary.cgColor]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil)
            
            if let gradient = gradient {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }
            
            // Add text
            let text = "MIL"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 48, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
    
    func uploadImage(_ image: UIImage, to path: String) async throws -> String {
        Logger.database("Mock upload image to path: \(path)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Validate image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.invalidImage
        }
        
        // Store mock data
        mockImages[path] = image
        mockFiles[path] = imageData
        
        Logger.database("Successfully uploaded image to: \(path)")
        return path
    }
    
    func uploadData(_ data: Data, to path: String) async throws -> String {
        Logger.database("Mock upload data to path: \(path)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Store mock data
        mockFiles[path] = data
        
        Logger.database("Successfully uploaded data to: \(path)")
        return path
    }
    
    func downloadImage(from path: String) async throws -> UIImage {
        Logger.database("Mock download image from path: \(path)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        guard let image = mockImages[path] else {
            throw StorageError.fileNotFound
        }
        
        Logger.database("Successfully downloaded image from: \(path)")
        return image
    }
    
    func downloadData(from path: String) async throws -> Data {
        Logger.database("Mock download data from path: \(path)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        guard let data = mockFiles[path] else {
            throw StorageError.fileNotFound
        }
        
        Logger.database("Successfully downloaded data from: \(path)")
        return data
    }
    
    func deleteFile(at path: String) async throws {
        Logger.database("Mock delete file at path: \(path)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        mockFiles.removeValue(forKey: path)
        mockImages.removeValue(forKey: path)
        
        Logger.database("Successfully deleted file at: \(path)")
    }
    
    func getDownloadURL(for path: String) async throws -> URL {
        Logger.database("Mock get download URL for path: \(path)")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        guard mockFiles[path] != nil || mockImages[path] != nil else {
            throw StorageError.fileNotFound
        }
        
        // Return a mock URL
        let url = URL(string: "https://mock-storage.com/\(path)")!
        Logger.database("Generated download URL: \(url)")
        return url
    }
}

// MARK: - Image Processing Extensions
extension StorageServiceProtocol {
    func uploadProfileImage(_ image: UIImage, for userId: String) async throws -> String {
        let path = "profile-images/\(userId).jpg"
        return try await uploadImage(image, to: path)
    }
    
    func downloadProfileImage(for userId: String) async throws -> UIImage {
        let path = "profile-images/\(userId).jpg"
        return try await downloadImage(from: path)
    }
}

// MARK: - Firebase Storage Service
#if canImport(FirebaseStorage)
class FirebaseStorageService: StorageServiceProtocol {
    private let storage = FirebaseManager.shared.storage
    
    func uploadImage(_ image: UIImage, to path: String) async throws -> String {
        Logger.database("Firebase upload image to path: \(path)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.invalidImage
        }
        
        let storageRef = storage.reference().child(path)
        
        do {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            Logger.database("Successfully uploaded image to: \(path)")
            return path
        } catch {
            Logger.error("Failed to upload image: \(error.localizedDescription)")
            throw StorageError.unknown(error.localizedDescription)
        }
    }
    
    func uploadData(_ data: Data, to path: String) async throws -> String {
        Logger.database("Firebase upload data to path: \(path)")
        
        let storageRef = storage.reference().child(path)
        
        do {
            _ = try await storageRef.putDataAsync(data)
            Logger.database("Successfully uploaded data to: \(path)")
            return path
        } catch {
            Logger.error("Failed to upload data: \(error.localizedDescription)")
            throw StorageError.unknown(error.localizedDescription)
        }
    }
    
    func downloadImage(from path: String) async throws -> UIImage {
        Logger.database("Firebase download image from path: \(path)")
        
        let storageRef = storage.reference().child(path)
        
        do {
            let data = try await storageRef.data(maxSize: 10 * 1024 * 1024) // 10MB limit
            guard let image = UIImage(data: data) else {
                throw StorageError.invalidImage
            }
            
            Logger.database("Successfully downloaded image from: \(path)")
            return image
        } catch {
            Logger.error("Failed to download image: \(error.localizedDescription)")
            throw StorageError.unknown(error.localizedDescription)
        }
    }
    
    func downloadData(from path: String) async throws -> Data {
        Logger.database("Firebase download data from path: \(path)")
        
        let storageRef = storage.reference().child(path)
        
        do {
            let data = try await storageRef.data(maxSize: 10 * 1024 * 1024) // 10MB limit
            Logger.database("Successfully downloaded data from: \(path)")
            return data
        } catch {
            Logger.error("Failed to download data: \(error.localizedDescription)")
            throw StorageError.unknown(error.localizedDescription)
        }
    }
    
    func deleteFile(at path: String) async throws {
        Logger.database("Firebase delete file at path: \(path)")
        
        let storageRef = storage.reference().child(path)
        
        do {
            try await storageRef.delete()
            Logger.database("Successfully deleted file at: \(path)")
        } catch {
            Logger.error("Failed to delete file: \(error.localizedDescription)")
            throw StorageError.unknown(error.localizedDescription)
        }
    }
    
    func getDownloadURL(for path: String) async throws -> URL {
        Logger.database("Firebase get download URL for path: \(path)")
        
        let storageRef = storage.reference().child(path)
        
        do {
            let url = try await storageRef.downloadURL()
            Logger.database("Generated download URL: \(url)")
            return url
        } catch {
            Logger.error("Failed to get download URL: \(error.localizedDescription)")
            throw StorageError.unknown(error.localizedDescription)
        }
    }
}
#endif
