//
//  NoteModel.swift
//  notes
//
//  Created by Dason Tiovino on 10/07/24.
//

import Foundation
import SwiftData

@Model
class RegularNote: Identifiable{
    var id: UUID
    var title: String
    var noteBody: String
    var date: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        noteBody: String,
        date: Date
    ) {
        self.id = id
        self.title = title
        self.noteBody = noteBody
        self.date = date
        
    }
}
