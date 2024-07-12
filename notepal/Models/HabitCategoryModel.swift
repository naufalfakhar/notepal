//
//  HabitCategoryModel.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import Foundation
import SwiftData

@Model
class HabitCategory: Identifiable {
    var id: UUID
    var category: String
    
    init(id: UUID, category: String) {
        self.id = id
        self.category = category
    }
}
