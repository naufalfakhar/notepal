//
//  FolderViewModel.swift
//  notepal
//
//  Created by Dason Tiovino on 15/07/24.
//

import Foundation
import Combine
import SwiftData

class FolderViewModel: ObservableObject{
    var modelContext: ModelContext? = nil
    
    @Published var data: [Folder] = []
    
    func fetchAll() {
        let descriptor = FetchDescriptor<Folder>(sortBy: [SortDescriptor(\.title)])
        if let context = modelContext {
            data = (try? context.fetch(descriptor)) ?? []
        }
    }
    
    func fetchById(id:String){
        if let id = UUID(uuidString: id){
            let descriptor = FetchDescriptor<Folder>(predicate: #Predicate{$0.id == id})
            if let context = modelContext {
                data = (try? context.fetch(descriptor)) ?? []
            }
        }
    }
    
    func addFolder(newFolder: Folder) {
        if let context = modelContext {
            context.insert(newFolder)
            try? context.save()
            fetchAll()
        }
    }
    
    func deleteFolder(id:String){
        guard let uuid = UUID(uuidString: id) else {
            print("Invalid UUID string: \(id)")
            return
        }
        
        if let context = modelContext{
            try? context.delete(model: Folder.self, where: #Predicate{
                $0.id == uuid
            })
            try? context.save()
            fetchAll()
        
        }
    }
}

