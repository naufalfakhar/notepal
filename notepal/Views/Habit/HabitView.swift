//
//  HabitView.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import SwiftUI
//import SwiftData
//import UIKit
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
        NavigationStack{
            VStack {
                if (!$habitViewModel.data.isEmpty || !$folderViewModel.data.isEmpty) {
                    List{
                        ForEach($folderViewModel.data){ folder in
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
                        ForEach($habitViewModel.data){ habit in
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
                //            viewModel.clearAll()
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
                            folderViewModel.addFolder(Folder(title:folderTitleInput))
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
            habitViewModel.modelContext = modelContext
            folderViewModel.modelContext = modelContext
            
            folderViewModel.fetchAll()
            habitViewModel.fetchAll()
        }
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
