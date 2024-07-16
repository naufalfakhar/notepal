import SwiftUI
import SwiftData

struct NoteRowView: View {
    let note: RegularNote
    let context: ModelContext
    
    var body: some View {
        NavigationLink(destination: UpdateNoteSheet(note: note)) {
            VStack(alignment: .leading) {
                Text(note.title)
                    .foregroundColor(.black)
                    .font(.headline)
                    .bold()
                Text(note.noteBody)
                    .font(.body)
                    .padding(.vertical)
            }
        }
        .contextMenu {
            Button("Delete") {
                context.delete(note)
                try? context.save()
            }
        }
    }
}
