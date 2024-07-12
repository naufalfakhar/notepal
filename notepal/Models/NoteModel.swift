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
    
    init(id: UUID = UUID(), contents: [NoteLog] = [
        NoteLog()
    ]) {
        self.id = id
        self.contents = contents
    }
}
