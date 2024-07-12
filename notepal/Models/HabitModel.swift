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
    var plans: [Checklist]
    var isCompleted: Bool
    
    init(
        id: UUID,
        folderId: UUID? = nil,
        title: String,
        goal: String,
        plan: [Checklist],
        note: Note = Note(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.folderId = folderId
        self.title = title
        self.goal = goal
        self.plans = plan
        self.note = note
        self.isCompleted = isCompleted
    }
}

