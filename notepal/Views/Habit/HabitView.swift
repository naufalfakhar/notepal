//
//  HabitView.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import SwiftUI
//import SwiftData
//import UIKit

struct HabitView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel = HabitViewModel()
    @State private var searchValue = ""
    
    @State private var showCreateSheet = false
    @State private var folderTitleInput: String = ""
    
    var body: some View {
        NavigationStack{
            VStack {
                if (!$viewModel.habitData.isEmpty || !$viewModel.folderData.isEmpty) {
                    List{
                        ForEach($viewModel.folderData){ folder in
                            Section {
                                NavigationLink{
                                    // TODO: Navigate to Detail Folder
                                } label: {
                                    HStack {
                                        Image(systemName: "folder")
                                        Text(folder.title.wrappedValue)
                                    }
                                }
                            }
                        }
                        ForEach($viewModel.habitData){ habit in
                            Section {
                                NavigationLink{
                                    // TODO: Navigate to Detail Habit
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
            Button {
                viewModel.clearAll()
            } label: {
                Text("Clear All")
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {}, label: {
                        Image(systemName: "list.bullet")
                    })
                    Button(action: {}, label: {
                        Image(systemName: "chart.xyaxis.line")
                    })
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        showCreateSheet.toggle()
                    }, label: {
                        Image(systemName: "folder.badge.plus")
                    })
                    NavigationLink{
                        HabitDetailView()
                            .toolbarRole(.editor)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateSheet, content: {
            NavigationStack {
                VStack {
                    TextField("Enter folder name", text: $folderTitleInput)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Spacer()
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            showCreateSheet = false
                        }, label: {
                            Text("Cancel")
                        })
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.addFolder(withTitle: folderTitleInput)
                            folderTitleInput = ""
                            showCreateSheet = false
                        }, label: {
                            Text("Done")
                        })
                    }
                }
            }
        })
        .onAppear{
            viewModel.modelContext = modelContext
            viewModel.fetchFolderData()
            viewModel.fetchHabitData()
        }
    }
}

#Preview {
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
