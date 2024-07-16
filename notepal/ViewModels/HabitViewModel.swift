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
    
    @Published var data: [Habit] = []
    
    func fetchAll() {
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.title)])
        if let context = modelContext {
            data = (try? context.fetch(descriptor)) ?? []
        }
    }
    
    func fetchById(id:String){
        if let id = UUID(uuidString: id){
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate{$0.id == id})
            if let context = modelContext {
                data = (try? context.fetch(descriptor)) ?? []
            }
        }
    }
    
    func addHabit(newHabit: Habit) {
        if let context = modelContext {
            
            context.insert(newHabit)
            try? context.save()
            
            fetchAll()
        }
    }
    
    func deleteHabit(id:String){
        if let id = UUID(uuidString: id){
            if let context = modelContext{
                try? context.delete(model: Habit.self, where: #Predicate{
                    $0.id == id
                })
                
                try? context.save()
                fetchAll()
            }
        }
        
    }
    
//    Clear all data
//    func clearAll(){
//        if let context = modelContext {
//            try? context.delete(model: Habit.self)
//            try? context.delete(model: Note.self)
//            try? context.delete(model: NoteLog.self)
//            try? context.delete(model: Folder.self)
//    
//            try? context.save()
//        }
//    }
}
