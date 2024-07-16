import SwiftUI
import SwiftData

struct RegularNoteView: View {
    @Query(sort: \Note.date) var notes: [Note]
    @Environment(\.modelContext) var context
    @State private var noteToEdit: Note?
    
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
