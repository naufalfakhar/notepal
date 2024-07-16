import SwiftUI
import SwiftData

struct NoteListView: View {
    let notes: [RegularNote]
    let context: ModelContext
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NoteRowView(note: note, context: context)
            }
        }
    }
}
