import SwiftUI

struct EmptyNotesView: View {
    var body: some View {
        VStack {
            ContentUnavailableView(label: {
                Label("No Notes", systemImage: "list.bullet.rectangle.portrait")
                    .font(.title3)
            }, description: {
                Text("Start adding notes")
                    .foregroundColor(.secondary)
            }, actions: {
                NavigationLink(destination: AddNoteSheet()) {
                    Text("Add Note")
                }
                .buttonStyle(.borderedProminent)
            })
        }
    }
}
