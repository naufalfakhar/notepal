//
//  HabitLogViewModel.swift
//  notepal
//
//  Created by Hansen Yudistira on 16/07/24.
//

import Foundation
import SwiftData
import Combine

class HabitLogViewModel: ObservableObject {
    var modelContext: ModelContext? = nil
    @Published var habitLogs: [HabitLog] = []
    
    func fetchStreak(title: String) -> Int {
        var streak = 0
        
        let reversedLogs = habitLogs.reversed()
        if reversedLogs.count > 1 {
            for i in 1..<reversedLogs.count {
                let log = reversedLogs[reversedLogs.index(reversedLogs.startIndex, offsetBy: i)]
                if let habitIndex = log.habitNameLogs.firstIndex(of: title) {
                    if log.habitCompleteLogs[habitIndex] {
                        streak += 1
                    } else {
                        break
                    }
                } else {
                    break
                }
            }
        }
        

        return streak
    }
    
    func fetchAll() {
        let descriptor = FetchDescriptor<HabitLog>(sortBy: [SortDescriptor(\.date)])
        if let context = modelContext {
            habitLogs = (try? context.fetch(descriptor)) ?? []
        }
    }
}
