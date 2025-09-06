//
//  DashboardViewModel.swift
//  Miltrack
//
//  Created by Jayland stitt on 9/6/25.
//

import SwiftUI
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var readinessScore = 85
    @Published var ptScore = 92
    @Published var todayTasks: [DashboardTask] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockData()
    }
    
    func refreshData() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Refresh mock data
        loadMockData()
        
        isLoading = false
    }
    
    private func loadMockData() {
        todayTasks = [
            DashboardTask(
                id: "1",
                title: "Morning PT",
                time: "6:00 AM",
                status: .pending,
                type: .fitness
            ),
            DashboardTask(
                id: "2",
                title: "Equipment Check",
                time: "9:00 AM",
                status: .upcoming,
                type: .maintenance
            ),
            DashboardTask(
                id: "3",
                title: "Team Meeting",
                time: "2:00 PM",
                status: .completed,
                type: .administrative
            )
        ]
    }
}

// MARK: - Dashboard Models
struct DashboardTask: Identifiable {
    let id: String
    let title: String
    let time: String
    let status: TaskStatus
    let type: TaskType
    
    enum TaskStatus {
        case pending
        case upcoming
        case completed
        case overdue
        
        var tagKind: MILTag.Kind {
            switch self {
            case .pending:
                return .warning
            case .upcoming:
                return .info
            case .completed:
                return .success
            case .overdue:
                return .error
            }
        }
        
        var icon: String {
            switch self {
            case .pending:
                return "clock"
            case .upcoming:
                return "calendar"
            case .completed:
                return "checkmark"
            case .overdue:
                return "exclamationmark"
            }
        }
        
        var displayText: String {
            switch self {
            case .pending:
                return "Pending"
            case .upcoming:
                return "Upcoming"
            case .completed:
                return "Completed"
            case .overdue:
                return "Overdue"
            }
        }
    }
    
    enum TaskType {
        case fitness
        case maintenance
        case administrative
        case training
        case health
        
        var color: Color {
            switch self {
            case .fitness:
                return MILColors.brandPrimary
            case .maintenance:
                return MILColors.warning
            case .administrative:
                return MILColors.info
            case .training:
                return MILColors.accent
            case .health:
                return MILColors.success
            }
        }
    }
}
