import SwiftUI
import SwiftData

struct AddNoteSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var date: Date = .now
    @State private var noteBody: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Note title", text: $title)
                    .padding(20)
                    .font(.title)
                    .bold()
                
                TextField("Write Something", text: $noteBody)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if !title.isEmpty || !noteBody.isEmpty {
                    let note = RegularNote(title: title, noteBody: noteBody, date: date)
                    context.insert(note)
                    try? context.save()
                }
            }
        }
    }
}
