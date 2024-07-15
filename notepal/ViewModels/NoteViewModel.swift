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
    
    @Published var data: [Habit] = []
    @Published var isActive: Bool = false
    
    func fetchById(id:String){
        if let uuid = UUID(uuidString: id) {
            print(uuid)
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.id == uuid })
            if let context = modelContext {
                data = (try? context.fetch(descriptor)) ?? []
                print(data)
            }
        }
    }
}

