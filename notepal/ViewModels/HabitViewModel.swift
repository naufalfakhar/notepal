//
//  HabitViewModel.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import Foundation
import Combine
import SwiftData


class HabitViewModel: ObservableObject{
    var modelContext: ModelContext? = nil
    
    @Published var folderData: [Folder] = []
    @Published var data: [Habit] = []
    
    func fetchHabitData() {
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.title)])
        if let context = modelContext {
            data = (try? context.fetch(descriptor)) ?? []
        }
    }
    
    func fetchHabitDataById(id: String) {
        if let uuid = UUID(uuidString: id) {
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.id == uuid })
            if let context = modelContext {
                data = (try? context.fetch(descriptor)) ?? []
            }
        }
    }
    
    func fetchFolderData() {
        let descriptor = FetchDescriptor<Folder>(sortBy: [SortDescriptor(\.title)])
        if let context = modelContext {
            folderData = (try? context.fetch(descriptor)) ?? []
        }
    }
    
    func addHabit() {
        let newHabit = Habit(
            id: UUID(),
            title: "New Title",
            goal: "Making new habit",
            plan: [
                Checklist(
                    id: UUID(),
                    content: "New Habit plan",
                    done: false
                ),
                Checklist(
                    id: UUID(),
                    content: "New Habit plan",
                    done: false
                ),
            ]
        )
        
        if let context = modelContext {
            context.insert(newHabit)
            try? context.save()
            fetchHabitData()
        }
    }
    
    func addHabitToRandomFolder() {
        if let lastHabit = data.last, let randomFolder = folderData.randomElement() {
            lastHabit.folderId = randomFolder.id
            try? modelContext?.save()
            fetchFolderData()
            fetchHabitData()
        }
    }
    
    func addFolder() {
        let newFolder = Folder(title: "Folder")
        
        if let context = modelContext {
            context.insert(newFolder)
            try? context.save()
            fetchFolderData()
        }
    }
    
    func addSubFolder() {
        if let firstFolder = folderData.first {
            let newFolder = Folder(title: "SubFolder", parentId: firstFolder.id)
            if let context = modelContext {
                context.insert(newFolder)
                try? context.save()
                fetchFolderData()
            }
        }
    }
    
    func addSubFolderFolder() {
        if let lastFolder = folderData.last {
            let newFolder = Folder(title: "SubFolder", parentId: lastFolder.id)
            if let context = modelContext {
                context.insert(newFolder)
                try? context.save()
                fetchFolderData()
            }
        }
    }
    
    func deleteHabit(_ model: Habit) {
        if let context = modelContext {
            context.delete(model)
            try? context.save()
            fetchHabitData()
        }
    }
    
    func clearAll() {
        if let context = modelContext {
            try? context.delete(model: Habit.self)
            try? context.delete(model: Note.self)
            try? context.delete(model: NoteLog.self)
            try? context.delete(model: Folder.self)
            try? context.save()
            fetchHabitData()
            fetchFolderData()
        }
    }
}

