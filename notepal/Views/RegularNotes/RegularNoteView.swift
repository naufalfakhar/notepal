//
//  RegularNoteView.swift
//  notepal
//
//  Created by Juan Carlos Manuel on 16/07/24.
//
import SwiftUI
import SwiftData

struct RegularNoteView: View {
    @Query(sort: \RegularNote.date) var notes: [RegularNote]
    @Environment(\.modelContext) var context
    @State private var noteToEdit: RegularNote?
    
    var body: some View {
        NavigationStack {
            VStack {
                NoteListView(notes: notes, context: context)
                    .sheet(item: $noteToEdit) { note in
                        UpdateNoteSheet(note: note)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AddNoteSheet()) {
                                Label("Add Note", systemImage: "plus")
                            }
                        }
                    }
                    .overlay {
                        if notes.isEmpty {
                            EmptyNotesView()
                        }
                    }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
