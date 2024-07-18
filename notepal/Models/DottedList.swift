//
//  ListModel.swift
//  notepal
//
//  Created by Dason Tiovino on 17/07/24.
//

import Foundation
import SwiftData

@Model
class DottedList: Identifiable  {
    var id : UUID
    var content: String
    
    init(id: UUID = UUID(), content: String) {
        self.id = id
        self.content = content
    }
}
