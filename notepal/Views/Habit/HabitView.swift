//
//  HabitView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 15/07/24.
//

import SwiftUI

struct HabitView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var habitVM = HabitViewModel()
    @State private var folderVM = FolderViewModel()
    
    @State private var searchValue = ""
    @State private var showCreateSheet = false
    @State private var newFolderTitle: String = ""
    
    var body: some View {
        VStack {
            if !$habitVM.data.isEmpty || !$folderVM.data.isEmpty {
                List {
                    ForEach($folderVM.data) { folder in
                        Section {
                            NavigationLink {
                                // TODO: Navigate to Detail Folder
                            } label: {
                                HStack {
                                    Image(systemName: "folder")
                                    Text(folder.title.wrappedValue)
                                }
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive, action: {
                                folderVM.deleteFolder(id: folder.id.wrappedValue.uuidString)
                            }, label: {
                                Label("Delete", systemImage: "trash")
                            })
                        }
                    }
                    ForEach($habitVM.data) { habit in
                        Section {
                            NavigationLink {
                                DetailHabitView(habit: habit.wrappedValue)
                                    .toolbarRole(.editor)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                HStack {
                                    Image(systemName: "note.text")
                                    Text(habit.title.wrappedValue)
                                    Spacer()
                                    Text("5")
                                    ZStack{
                                        Image(systemName: "flame")
                                            .foregroundStyle(.linearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
                                        Image(systemName: "flame.fill")
                                            .foregroundStyle(.linearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
                                    }
                                }
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive, action: {
                                habitVM.deleteHabit(id: habit.id.wrappedValue.uuidString)
                            }, label: {
                                Label("Delete", systemImage: "trash")
                            })
                        }
                    }
                    
                }
                .listSectionSpacing(.compact)
            } else {
                Text("No items yet.")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Habit Journey")
        .searchable(text: $searchValue, prompt: "Search")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    showCreateSheet.toggle()
                }, label: {
                    Image(systemName: "folder.badge.plus")
                })
                NavigationLink {
                    CreateHabitView()
                        .toolbarRole(.editor)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            NavigationStack {
                VStack {
                    TextField("New Folder", text: $newFolderTitle)
                        .textFieldStyle(.roundedBorder)
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(action: {
                            showCreateSheet = false
                        }, label: {
                            Text("Cancel")
                        })
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: {
                            folderVM.addFolder(newFolder: Folder(title: newFolderTitle))
                            newFolderTitle = ""
                            showCreateSheet = false
                        }, label: {
                            Text("Done")
                        })
                    }
                }
            }
        }
        .onAppear {
            folderVM.modelContext = modelContext
            habitVM.modelContext = modelContext
            
            folderVM.fetchAll()
            habitVM.fetchAll()
        }
    }
}

#Preview {
    NavigationStack {
        HabitView()
            .modelContainer(for: [
                Habit.self,
                Folder.self,
                Note.self,
                NoteLog.self,
                Checklist.self
            ])
    }
}
