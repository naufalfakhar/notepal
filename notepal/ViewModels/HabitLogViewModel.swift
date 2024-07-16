//
//  HabitLogViewModel.swift
//  notepal
//
//  Created by Hansen Yudistira on 16/07/24.
//

import Foundation
import SwiftData

class HabitLogViewModel: Observable {
    var modelContext: ModelContext? = nil
    @Published var habitLogs: [HabitLog] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
    
    func fetchHabitLog(for date: Date) -> HabitLog? {
        return habitLogs.first(where: { $0.date == date })
    }
    
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<HabitLog>(sortBy: [SortDescriptor(\.date)])
            habitLogs = try modelContext!.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
}
