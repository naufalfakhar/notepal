//
//  HabitView.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import SwiftUI
import SwiftData

struct HabitView: View {
    @Environment(\.modelContext) var modelContext
    
    @StateObject private var habitViewModel = HabitViewModel()
    @StateObject private var folderViewModel = FolderViewModel()
    @State private var searchValue = ""
    
    @State private var showCreateSheet = false
    @State private var folderTitleInput: String = ""
    
    var body: some View {
            VStack {
                if !$habitViewModel.data.isEmpty || !$folderViewModel.data.isEmpty {
                    List {
                        ForEach($folderViewModel.data) { folder in
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
                        }
                        ForEach($habitViewModel.data) { habit in
                            Section {
                                NavigationLink {
                                    HabitDetailView(id: habit.id.uuidString)
                                } label: {
                                    HStack {
                                        Text(habit.title.wrappedValue)
                                    }
                                }
                            }
                        }
                        .swipeActions {
                            Button(action: {
                                // TODO: Delete Action
                            }, label: {
                                Image(systemName: "trash")
                            })
                            .tint(.red)
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
                        HabitDetailView()
                            .toolbarRole(.editor)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .onAppear {
                habitViewModel.modelContext = modelContext
                folderViewModel.modelContext = modelContext
                
                folderViewModel.fetchAll()
                habitViewModel.fetchAll()
                
            }
            .sheet(isPresented: $showCreateSheet, content: {
                NavigationStack{
                    VStack {
                        TextField("Enter folder name", text: $folderTitleInput)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        Spacer()
                        
//                        // Clearning All Data
//                        Button{
//                            habitViewModel.clearAll()
//                        }label:{
//                            Text("Clear All")
//                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showCreateSheet = false
                            }, label: {
                                Text("Cancel")
                            })
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                folderViewModel.addFolder(newFolder: Folder(title: folderTitleInput))
                                folderTitleInput = ""
                                showCreateSheet = false
                            }, label: {
                                Text("Done")
                            })
                        }
                    }
                }
                
            })
        }
    
}

#Preview {
    NavigationStack {
        HabitView()
            .modelContainer(for: [
                Note.self,
                NoteLog.self,
                HabitCategory.self,
                Habit.self,
                HabitLog.self,
                Folder.self,
                Checklist.self,
            ])
    }
}
