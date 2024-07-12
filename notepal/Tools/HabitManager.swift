//
//  HabitManager.swift
//  HabitDaily
//
//  Created by Hansen Yudistira on 09/07/24.
//

import SwiftUI
import SwiftData

class HabitManager: ObservableObject {
    private let lastSavedDateKey = "lastSavedDate"
    
    func checkAndLogHabits(modelContext: ModelContext) {
        guard let lastSavedDate = UserDefaults.standard.object(forKey: lastSavedDateKey) as? Date else {
            // If not, set the current date as the last saved date and return
            let currentDate = Date()
            UserDefaults.standard.set(currentDate, forKey: lastSavedDateKey)
            print("First run, setting last saved date to \(currentDate)")
            return
        }

        let currentDate = Date()
        print("current date: \(currentDate)")
        print("Last saved date: \(lastSavedDate)")
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let strippedLastSavedDate = calendar.startOfDay(for: lastSavedDate)
        let strippedCurrentDate = calendar.startOfDay(for: currentDate)
        
        var nextDate = strippedLastSavedDate
        
        print("Stripped last saved date: \(strippedLastSavedDate)")
        print("Stripped current date: \(strippedCurrentDate)")
        // If more than a day has passed since the last saved date
        while let nextDay = calendar.date(byAdding: .day, value: 1, to: nextDate), nextDay <= strippedCurrentDate {
            nextDate = calendar.startOfDay(for: nextDay)
            print("tanggal next date \(nextDate)")
            saveHabitsToLogAndReset(for: nextDate, modelContext: modelContext)
            UserDefaults.standard.set(nextDate, forKey: lastSavedDateKey)
        }

        UserDefaults.standard.set(currentDate, forKey: lastSavedDateKey)
    }

    private func saveHabitsToLogAndReset(for date: Date, modelContext: ModelContext) {
        do {
            let habits: [Habit] = try modelContext.fetch(FetchDescriptor<Habit>())
            
            let habitNameLogs = habits.map { $0.name }
            let habitCompleteLogs = habits.map { $0.isCompleted }
            
            // Create a new log
            let log = HabitLog(date: date, habitNameLogs: habitNameLogs, habitCompleteLogs: habitCompleteLogs)
            modelContext.insert(log)

            // Reset all habits
            for habit in habits {
                habit.isCompleted = false
            }

            try modelContext.save()
        } catch {
            print("Failed to fetch or save habits: \(error)")
        }
    }
}
