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
            Checklist.self,
            HabitLog.self,
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
                .onReceive(NotificationCenter.default.publisher(for: .didReceiveCustomURL)) { notification in
                    if let url = notification.object as? URL {
                        handleCustomURL(url)
                    }
                }
                .modelContainer(sharedModelContainer)
        }
    }

    private func handleCustomURL(_ url: URL) {
        // Handle the URL and perform any specific actions
        if let host = url.host {
            // For example, navigate to a specific note based on the URL
            print("Custom URL host: \(host)")
        }
    }
}
