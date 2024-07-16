//
//  HabitNoteModel.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import Foundation
import SwiftData

@Model
class Habit: Identifiable{
    var id: UUID
    var folderId: UUID?
    var note: Note
    var title: String
    var goal: String
//    var plan: String
//    var need: String
    var plans: [Checklist]?
    var isCompleted: Bool?
    
    init(
        id: UUID = UUID(),
        folderId: UUID? = nil,
        note: Note = Note(),
        title: String,
        goal: String,
//        plan: String,
//        need: String,
        plans: [Checklist] = [],
        isCompleted: Bool = false
    ) {
        self.id = id
        self.folderId = folderId
        
        self.note = note
        self.title = title
        self.goal = goal
//        self.plan = plan
//        self.need = need
        self.plans = plans
        self.isCompleted = isCompleted
    }
}

