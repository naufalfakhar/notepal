//
//  NoteModel.swift
//  notes
//
//  Created by Dason Tiovino on 10/07/24.
//

import Foundation
import SwiftData

@Model
class Note: Identifiable{
    var id: UUID
    var contents: [NoteLog]
    var title: String
    var noteBody: String
    var date: Date
    
    init(id: UUID = UUID(), contents: [NoteLog] = [
        NoteLog()
    ],title: String, noteBody: String, date: Date) {
        self.id = id
        self.contents = contents
        self.title = title
        self.noteBody = noteBody
        self.date = date
    }
}
