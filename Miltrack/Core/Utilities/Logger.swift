//
//  Logger.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import Foundation
import os.log

enum LogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
}

struct Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.miltrack.app"
    
    // MARK: - Category Loggers
    static let auth = OSLog(subsystem: subsystem, category: "Auth")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let database = OSLog(subsystem: subsystem, category: "Database")
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let analytics = OSLog(subsystem: subsystem, category: "Analytics")
    static let performance = OSLog(subsystem: subsystem, category: "Performance")
    
    // MARK: - Logging Methods
    static func debug(_ message: String, category: OSLog = .default, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, category: OSLog = .default, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, category: OSLog = .default, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, category: OSLog = .default, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
    
    static func critical(_ message: String, category: OSLog = .default, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .critical, category: category, file: file, function: function, line: line)
    }
    
    // MARK: - Private Logging Implementation
    private static func log(_ message: String, level: LogLevel, category: OSLog, file: String, function: String, line: Int) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[\(level.rawValue)] \(fileName):\(line) \(function) - \(message)"
        
        let osLogType: OSLogType
        switch level {
        case .debug:
            osLogType = .debug
        case .info:
            osLogType = .info
        case .warning:
            osLogType = .default
        case .error:
            osLogType = .error
        case .critical:
            osLogType = .fault
        }
        
        os_log("%{public}@", log: category, type: osLogType, logMessage)
        
        // Also print to console in debug builds
        #if DEBUG
        print(logMessage)
        #endif
    }
}

// MARK: - Convenience Extensions
extension Logger {
    static func auth(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, category: auth, file: file, function: function, line: line)
    }
    
    static func network(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, category: network, file: file, function: function, line: line)
    }
    
    static func database(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, category: database, file: file, function: function, line: line)
    }
    
    static func ui(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, category: ui, file: file, function: function, line: line)
    }
    
    static func analytics(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, category: analytics, file: file, function: function, line: line)
    }
    
    static func performance(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: level, category: performance, file: file, function: function, line: line)
    }
}
