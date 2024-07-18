//
//  notepalApp.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 12/07/24.
//

import SwiftUI
import SwiftData

@main
struct MyNotesApp: App {
    @StateObject private var habitManager = HabitManager()
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
            NoteLog.self,
            HabitCategory.self,
            Habit.self,
            Folder.self,
            DottedList.self,
            Checklist.self,
            HabitLog.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationViewModel())
                .modelContainer(sharedModelContainer)
                .onAppear {
                    habitManager.checkAndLogHabits(modelContext: sharedModelContainer.mainContext)
                }
        }
    }
}
