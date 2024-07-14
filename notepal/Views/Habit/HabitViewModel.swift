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
    var habitData: [Habit] = []
    
    func fetchHabitData(){
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.title)])
        habitData = (try? (modelContext?.fetch(descriptor) ?? []))!
        
        print(habitData)
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
    
//    func addHabitToRandomFolder(){
//        habitData.last?.folderId = folderData.randomElement()?.id
//        try? modelContext?.save()
//        fetchFolderData()
//        fetchHabitData()
//    }
    
    func addFolder(withTitle title:String){
        let newFolder = Folder(title: title)
        
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
    
    func deleteHabit(_ model: Habit){
        modelContext?.delete(model)
    }
    
    func clearAll(){
        try? modelContext?.delete(model: Folder.self)
        try? modelContext?.delete(model: Habit.self)
//        try? modelContext?.delete(model: Note.self)
//        try? modelContext?.delete(model: NoteLog.self)
        fetchFolderData()
        fetchHabitData()
    }
}

