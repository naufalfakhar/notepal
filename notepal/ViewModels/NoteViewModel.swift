//
//  NoteViewModel.swift
//  notes
//
//  Created by Dason Tiovino on 10/07/24.
//

import Foundation
import Combine
import SwiftData


class NoteViewModel: ObservableObject{
    var modelContext: ModelContext? = nil
    
    @Published var data: [Note] = []
    
    func fetchAll() {
        let descriptor = FetchDescriptor<Note>()
        if let context = modelContext {
            data = (try? context.fetch(descriptor)) ?? []
        }
    }
    
    func fetchById(id:String){
        if let id = UUID(uuidString: id){
            let descriptor = FetchDescriptor<Note>(predicate: #Predicate{$0.id == id})
            if let context = modelContext {
                data = (try? context.fetch(descriptor)) ?? []
            }
        }
    }
    
    func addNote(newFolder: Note) {
        if let context = modelContext {
            context.insert(newFolder)
            try? context.save()
            fetchAll()
        }
    }
    
    func deleteNote(id:String){
        if let id = UUID(uuidString: id){
            if let context = modelContext{
                try? context.delete(model: Note.self, where: #Predicate{
                    $0.id == id
                })
                
                try? context.save()
                fetchAll()
            }
        }
        
    }
}
