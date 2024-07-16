//
//  NoteLogModel.swift
//  notes
//
//  Created by Dason Tiovino on 11/07/24.
//
//
import Foundation
import SwiftData

extension NSMutableAttributedString {
    func toData() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }

    static func fromData(_ data: Data) -> NSMutableAttributedString? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSMutableAttributedString.self, from: data)
    }
}

@Model
class NoteLog: Identifiable{
    var id: UUID
    var contentData: Data
    var content: NSMutableAttributedString {
        get {
            NSMutableAttributedString.fromData(contentData) ?? NSMutableAttributedString(string: "")
        }
        set {
            contentData = newValue.toData() ?? Data()
        }
    }
    var createdAt: Date


    init(
        id: UUID = UUID(),
        content: NSMutableAttributedString = NSMutableAttributedString(string: "Type your activity here"),
        createdAt: Date = Date()
    ) {
        self.id = id
        self.contentData = content.toData() ?? Data() // Initialize contentData directly
        self.createdAt = createdAt
    }
}
