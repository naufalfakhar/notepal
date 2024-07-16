//
//  HabitManager.swift
//  HabitDaily
//
//  Created by Hansen Yudistira on 09/07/24.
//

import SwiftUI
import SwiftData

struct HabitDataLog {
    var date: Date
    var habitCount: Int
    var scheduled: Int
    var done: Int
    var missed: Int
}

struct HabitData: Identifiable {
    var id = UUID()
    var title: String
}

class HabitManager: ObservableObject {
    private let lastSavedDateKey = "lastSavedDate"
    
    func fetchHabitDaily(data: [Habit]) -> [HabitData] {
        return [
            HabitData(title: "Health Habit"),
            HabitData(title: "Workout Data"),
            HabitData(title: "Coding Habit")
        ]
    }
    
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
        
//        for i in 1...7 {
//            let oneWeekBeforeDate = calendar.date(byAdding: .day, value: -i, to: currentDate)!
//            let habitData = HabitLog(date: oneWeekBeforeDate, habitNameLogs: ["Health Habit", "Workout Habit", "Coding Habit"], habitCompleteLogs: [Bool.random(), Bool.random(), Bool.random()])
//            modelContext.insert(habitData)
//        }
//
//        for i in 1...7 {
//            let oneWeekBeforeDate = calendar.date(byAdding: .day, value: -i - 7, to: currentDate)!
//            let habitData = HabitLog(date: oneWeekBeforeDate, habitNameLogs: ["Health Habit", "Workout Habit", "Coding Habit"], habitCompleteLogs: [Bool.random(), Bool.random(), Bool.random()])
//            modelContext.insert(habitData)
//        }
//
//        let healthData = Habit(id: UUID(), title: "Health Habit", goal: "jadi sehat", plan: [Checklist(id: UUID(), content: "makan sehat", done: false)])
//        let workoutData = Habit(id: UUID(), title: "Workout Habit", goal: "jadi ade ray", plan: [Checklist(id: UUID(), content: "olahraga woy", done: false), Checklist(id: UUID(), content: "makan yang banyak", done: false)])
//        let codingData = Habit(id: UUID(), title: "Coding Habit", goal: "bisa ngoding", plan: [Checklist(id: UUID(), content: "kerjain challenge woy game mulu", done: false)])
//        modelContext.insert(healthData)
//        modelContext.insert(workoutData)
//        modelContext.insert(codingData)

        UserDefaults.standard.set(currentDate, forKey: lastSavedDateKey)
    }

    private func saveHabitsToLogAndReset(for date: Date, modelContext: ModelContext) {
        do {
            let habits: [Habit] = try modelContext.fetch(FetchDescriptor<Habit>())
            
            let habitNameLogs = habits.map { $0.title }
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
