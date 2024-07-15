//
//  HabitCardViewModel.swift
//  notepal
//
//  Created by Hansen Yudistira on 14/07/24.
//

import SwiftData
import SwiftUI

class HabitCardViewModel {
    @MainActor func fetchHabit(for title: String) -> Habit? {
        do {
            
            let schema = Schema([
                HabitLog.self,
                Habit.self,
                Note.self,
                Checklist.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
    
            let fetchedHabit: [Habit] = try modelContainer.mainContext.fetch(FetchDescriptor<Habit>())
            
            print(fetchedHabit)
            
            return fetchedHabit.first
        } catch {
            print("Failed to fetch Habit: \(error)")
            return nil
        }
    }
}
