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
    var index: Int
    var content: String
    var done: Bool
    
    init(var id: UUID = UUID(), index: Int, content: String, done: Bool = false) {
        self.id = id
        self.index = index
        self.content = content
        self.done = done
    }
}
