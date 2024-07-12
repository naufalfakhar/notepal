//
//  FolderModel.swift
//  notes
//
//  Created by Dason Tiovino on 10/07/24.
//

import Foundation
import SwiftData

@Model
class Folder: Identifiable{
    var id: UUID
    var parentId: UUID?
    var title: String
    
    init(id: UUID = UUID(), title: String, parentId: UUID? = nil) {
        self.id = id
        self.title = title
        self.parentId = parentId
    }
}

