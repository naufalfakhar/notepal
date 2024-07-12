//
//  HabitLog.swift
//  HabitDaily
//
//  Created by Hansen Yudistira on 10/07/24.
//

import Foundation
import SwiftData

@Model
class HabitLog: Identifiable {
    var id: UUID
    var date: Date
    var habitNameLogs: [String]
    var habitCompleteLogs: [Bool]
    
    init(id: UUID = UUID(), date: Date, habitNameLogs: [String] = [], habitCompleteLogs: [Bool] = []) {
        self.id = id
        self.date = date
        self.habitNameLogs = habitNameLogs
        self.habitCompleteLogs = habitCompleteLogs
    }
}
