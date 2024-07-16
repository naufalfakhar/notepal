import SwiftUI
import SwiftData

struct NoteListView: View {
    let notes: [Note]
    let context: ModelContext
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NoteRowView(note: note, context: context)
            }
        }
    }
}
