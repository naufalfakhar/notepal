//
//  HabitLogModel.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import Foundation
import SwiftData

@Model
class HabitLog: Identifiable{
    var id: UUID
    var data: Habit
    var createdAt: Date
    
    init(id: UUID, data: Habit, createdAt: Date) {
        self.id = id
        self.data = data
        self.createdAt = createdAt
    }
}

