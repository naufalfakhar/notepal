//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//    @Query(sort: \Note.date) var notes: [Note]
//    @Environment(\.modelContext) var context
//    @State private var noteToEdit: Note?
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                List {
//                    ForEach(notes) { note in
//                        NavigationLink(destination: UpdateNoteSheet(note: note)) {
//                            VStack(alignment: .leading) {
//                                Text(note.title)
//                                    .foregroundColor(.black)
//                                    .font(.headline)
//                                    .bold()
//                                Text(note.noteBody)
//                                    .font(.body)
//                                    .padding(.vertical)
//                            }
//                        }
//                        .contextMenu {
//                            Button("Delete") {
//                                context.delete(note)
//                                try? context.save()
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Notes")
//                .navigationBarTitleDisplayMode(.large)
//                .sheet(item: $noteToEdit) { note in
//                    UpdateNoteSheet(note: note)
//                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        NavigationLink(destination: AddNoteSheet()) {
//                            Label("Add Note", systemImage: "plus")
//                        }
//                    }
//                }
//                .overlay {
//                    if notes.isEmpty {
//                        VStack {
//                            ContentUnavailableView(label: {
//                                Label("No Notes", systemImage: "list.bullet.rectangle.portrait")
//                                    .font(.title3)
//                            }, description: {
//                                Text("Start adding notes")
//                                    .foregroundColor(.secondary)
//                            }, actions: {
//                                NavigationLink(destination: AddNoteSheet()) {
//                                    Text("Add Note")
//                                }
//                                .buttonStyle(.borderedProminent)
//                            })
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    struct AddNoteSheet: View {
//        @Environment(\.presentationMode) var presentationMode
//        @Environment(\.modelContext) var context
//        @Environment(\.dismiss) private var dismiss
//        
//        @State private var title: String = ""
//        @State private var date: Date = .now
//        @State private var noteBody: String = ""
//        
//        var body: some View {
//            NavigationStack {
//                VStack {
//                    TextField("Note title", text: $title)
//                        .padding(20)
//                        .font(.title)
//                        .bold()
//                    
//                    TextField("Note body", text: $noteBody)
//                        .padding(.horizontal)
//                    
//                    Spacer()
//                }
//                .navigationTitle("New Note")
//                .navigationBarTitleDisplayMode(.inline)
//                .onDisappear {
//                    if !title.isEmpty || !noteBody.isEmpty {
//                        let note = Note(title: title, noteBody: noteBody, date: date)
//                        context.insert(note)
//                        try? context.save()
//                    }
//                }
//            }
//        }
//    }
//    
//    struct UpdateNoteSheet: View {
//        @Environment(\.dismiss) private var dismiss
//        @Environment(\.modelContext) var context
//        @Bindable var note: Note
//        
//        var body: some View {
//            NavigationStack {
//                VStack {
//                    TextField("Note title", text: $note.title)
//                        .padding(20)
//                        .font(.title)
//                        .bold()
//                    
//                    TextField("Note body", text: $note.noteBody)
//                        .padding(.horizontal)
//                    
//                    Spacer()
//                }
//                
////                .navigationTitle("Update Note")
//                .navigationBarTitleDisplayMode(.inline)
//                .onDisappear {
//                    try? context.save()
//                }
//            }
//        }
//    }
//}

import SwiftUI
import SwiftData

struct ContentView: View {
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
