//
//  HabitViewModel.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import Foundation
import Combine
import SwiftData

@Observable
class HabitViewModel{
    var modelContext: ModelContext? = nil
    
    var folderData: [Folder] = []
    var data: [Habit] = []
    
    func fetchHabitData(){
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.title)])
        data = (try? (modelContext?.fetch(descriptor) ?? []))!
    }
    
    func fetchFolderData(){
        let descriptor = FetchDescriptor<Folder>(sortBy: [SortDescriptor(\.title)])
        folderData = (try? (modelContext?.fetch(descriptor) ?? []))!
        
        print(folderData)
    }
    
    func addHabit(){
        let newHabit = Habit(
            id: UUID(),
            title: "New Title",
            goal: "Making new habit",
            plan:[
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
        
        modelContext?.insert(newHabit)
        try? modelContext?.save()
        
        fetchHabitData()
    }
    
    func addHabitToRandomFolder(){
        data.last?.folderId = folderData.randomElement()?.id
        try? modelContext?.save()
        fetchFolderData()
        fetchHabitData()
    }
    
    func addFolder(){
        let newFolder = Folder(title: "Folder")
        
        modelContext?.insert(newFolder)
        try? modelContext?.save()
        
        fetchFolderData()
    }
    
    func addSubFolder(){
        let newFolder = Folder(title: "SubFolder", parentId: folderData.first?.id)
        modelContext?.insert(newFolder)
        try? modelContext?.save()
        
        fetchFolderData()
    }
    
    func addSubFolderFolder(){
        let newFolder = Folder(title: "SubFolder", parentId: folderData.last?.id)
        modelContext?.insert(newFolder)
        try? modelContext?.save()
        
        fetchFolderData()
    }
    
    func updateHabit(){
        
    }
    
    func deleteHabit(_ model: Habit){
        modelContext?.delete(model)
    }
    
    func clearAll(){
        try? modelContext?.delete(model: Habit.self)
        try? modelContext?.delete(model: Note.self)
        try? modelContext?.delete(model: NoteLog.self)
        try? modelContext?.delete(model: Folder.self)
    }
}

