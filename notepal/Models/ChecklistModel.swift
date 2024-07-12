//
//  ChecklistModel.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import Foundation
import SwiftData

@Model
class Checklist: Identifiable  {
    var id: UUID
    var content: String
    var done: Bool
    
    init(id: UUID, content: String, done: Bool) {
        self.id = id
        self.content = content
        self.done = done
    }
}
