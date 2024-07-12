//
//  notepalApp.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 12/07/24.
//

import SwiftUI

@main
struct notepalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: [
            Note.self,
            NoteLog.self,
            HabitCategory.self,
            Habit.self,
            HabitLog.self,
            Folder.self,
            Checklist.self,
        ])
    }
}
