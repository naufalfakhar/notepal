//
//  NoteViewModel.swift
//  notes
//
//  Created by Dason Tiovino on 10/07/24.
//

import Foundation
import Combine
import SwiftData

class NoteViewModel: Observable{
    var modelContext: ModelContext? = nil
    var data: [Habit] = []
    
    func fetchData(){
        do {
            let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.title)])
            data = (try? (modelContext?.fetch(descriptor) ?? []))!
        } catch {
            print("Fetch failed")
        }
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
        
        fetchData()
    }
    
    func updateHabit(){
        
    }
    
    func deleteHabit(_ model: Habit){
        modelContext?.delete(model)
    }
}

