//
//  HabitManager.swift
//  HabitDaily
//
//  Created by Hansen Yudistira on 09/07/24.
//

import SwiftUI
import SwiftData
import Foundation

class HabitManager: ObservableObject {
    private let lastSavedDateKey = "lastSavedDate"
    
    func fetchHabitLogsForPastWeek(modelContext: ModelContext) -> [HabitDataLog]{
        var logs: [HabitLog] = []
        
        do {
            logs = try modelContext.fetch(FetchDescriptor<HabitLog>())
        } catch {
            print(error)
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let today = calendar.startOfDay(for: Date())
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: today)!

        let logsForPastWeek = logs.filter { $0.date >= oneWeekAgo && $0.date <= today }
        
        var habitDataLogs: [HabitDataLog] = []
        var currentDate = oneWeekAgo
        
        while currentDate < today {
            let logForDate = logsForPastWeek.filter { calendar.isDate($0.date, inSameDayAs: currentDate) }
            let habitCount = logForDate.reduce(0) { $0 + $1.habitCompleteLogs.reduce(0) { $0 + ($1 ? 1 : 0) } }
            let scheduled = logForDate.reduce(0) { $0 + $1.habitCompleteLogs.count}
            let done = logForDate.reduce(0) { $0 + $1.habitCompleteLogs.filter { $0 }.count }
            let missed = scheduled - done
            habitDataLogs.append(HabitDataLog(date: currentDate, habitCount: habitCount, scheduled: scheduled, done: done, missed: missed))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return habitDataLogs
    }
    
    func fetchHabitLogsForPastTwoWeek(modelContext: ModelContext) -> [HabitDataLog]{
        var logs: [HabitLog] = []
        
        do {
            logs = try modelContext.fetch(FetchDescriptor<HabitLog>())
        } catch {
            print(error)
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let today = calendar.startOfDay(for: Date())
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: today)!
        let oneWeekAgo = calendar.date(byAdding: .day, value: -14, to: today)!

        let logsForPastWeek = logs.filter { $0.date >= oneWeekAgo && $0.date <= lastWeek }
        
        var habitDataLogs: [HabitDataLog] = []
        var currentDate = oneWeekAgo
        
        while currentDate < lastWeek {
            let logForDate = logsForPastWeek.filter { calendar.isDate($0.date, inSameDayAs: currentDate) }
            let habitCount = logForDate.reduce(0) { $0 + $1.habitCompleteLogs.reduce(0) { $0 + ($1 ? 1 : 0) } }
            let scheduled = logForDate.reduce(0) { $0 + $1.habitCompleteLogs.count}
            let done = logForDate.reduce(0) { $0 + $1.habitCompleteLogs.filter { $0 }.count }
            let missed = scheduled - done
            habitDataLogs.append(HabitDataLog(date: currentDate, habitCount: habitCount, scheduled: scheduled, done: done, missed: missed))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return habitDataLogs
    }
    
    func checkAndLogHabits(modelContext: ModelContext) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT+7") ?? TimeZone.current
        guard let lastSavedDate = UserDefaults.standard.object(forKey: lastSavedDateKey) as? Date else {
            // If not, set the current date as the last saved date and return
            let currentDate = Date()
            let savedDate = calendar.date(byAdding: .day, value: -1, to: currentDate)
            UserDefaults.standard.set(savedDate, forKey: lastSavedDateKey)
            print("First run, setting last saved date to \(currentDate)")
            return
        }

        let currentDate = Date()
        print("current date: \(currentDate)")
        print("Last saved date: \(lastSavedDate)")
        
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
        
        for i in 1...7 {
            let oneWeekBeforeDate = calendar.date(byAdding: .day, value: -i, to: currentDate)!
            let habitData = HabitLog(date: oneWeekBeforeDate, habitNameLogs: ["Health Habit", "Workout Habit", "Coding Habit"], habitCompleteLogs: [Bool.random(), Bool.random(), Bool.random()])
            modelContext.insert(habitData)
        }

        for i in 1...7 {
            let oneWeekBeforeDate = calendar.date(byAdding: .day, value: -i - 7, to: currentDate)!
            let habitData = HabitLog(date: oneWeekBeforeDate, habitNameLogs: ["Health Habit", "Workout Habit", "Coding Habit"], habitCompleteLogs: [Bool.random(), Bool.random(), Bool.random()])
            modelContext.insert(habitData)
        }

        UserDefaults.standard.set(currentDate, forKey: lastSavedDateKey)
    }

    private func saveHabitsToLogAndReset(for date: Date, modelContext: ModelContext) {
        do {
            let habits: [Habit] = try modelContext.fetch(FetchDescriptor<Habit>())
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "GMT+7") ?? TimeZone.current
            
            let habitNameLogs = habits.map { $0.title }
            var habitCompleteLogs = [Bool]()
            
            for habit in habits {
                let hasNoteLogForDate = habit.note.contains { calendar.isDate($0.createdAt, inSameDayAs: date) }

                if hasNoteLogForDate {
                    habit.isCompleted = true
                }

                habitCompleteLogs.append(habit.isCompleted)
            }
            
            let log = HabitLog(date: date, habitNameLogs: habitNameLogs, habitCompleteLogs: habitCompleteLogs)
            modelContext.insert(log)

            for habit in habits {
                habit.isCompleted = false
            }

            try modelContext.save()
        } catch {
            print("Failed to fetch or save habits: \(error)")
        }
    }
}
