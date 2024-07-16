import SwiftUI
import SwiftData

struct UpdateNoteSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @Bindable var note: RegularNote
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Note title", text: $note.title)
                    .padding(20)
                    .font(.title)
                    .bold()
                
                TextField("Write Something", text: $note.noteBody)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Update Note")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                try? context.save()
            }
        }
    }
}
