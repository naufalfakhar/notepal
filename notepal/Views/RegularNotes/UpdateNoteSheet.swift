import SwiftUI
import SwiftData

struct UpdateNoteSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @Bindable var note: Note
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Note title", text: $note.title)
                    .padding(20)
                    .font(.title)
                    .bold()
                    .focused($amountIsFocused)
                
                TextEditor (text: $note.noteBody)
                    .padding(.horizontal)
                    .focused($amountIsFocused)
                
                Spacer()
            }
            .toolbar{
                if amountIsFocused {
                    Button ("Done"){
                        amountIsFocused = false
                    }
                }
            }
            .navigationTitle("Update Note")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                try? context.save()
            }
        }
    }
}
