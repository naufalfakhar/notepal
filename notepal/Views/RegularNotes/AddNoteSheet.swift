import SwiftUI
import SwiftData

struct AddNoteSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @FocusState private var amountIsFocused: Bool

    
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
                    .focused($amountIsFocused)
                
                TextEditor(text: $noteBody)
                    .padding(.horizontal)
                    .focused($amountIsFocused)
                
                Spacer()
            }
            .toolbar
            {
                if amountIsFocused {
                    Button("done") {
                        amountIsFocused = false
                    }
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if !title.isEmpty || !noteBody.isEmpty {
                    let note = Note(title: title, noteBody: noteBody, date: date)
                    context.insert(note)
                    try? context.save()
                }
            }
        }
    }
}
