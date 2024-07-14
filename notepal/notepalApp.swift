//
//  notepalApp.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 12/07/24.
//

import SwiftUI

@main
struct MyNotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: .didReceiveCustomURL)) { notification in
                    if let url = notification.object as? URL {
                        handleCustomURL(url)
                    }
                }
                .modelContainer(for: [
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

    private func handleCustomURL(_ url: URL) {
        // Handle the URL and perform any specific actions
        if let host = url.host {
            // For example, navigate to a specific note based on the URL
            print("Custom URL host: \(host)")
        }
    }
}
