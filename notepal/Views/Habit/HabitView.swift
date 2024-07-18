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
    
    @StateObject private var habitVM = HabitViewModel()
    @StateObject private var folderVM = FolderViewModel()
    @State private var searchValue = ""
    
    @State private var showCreateSheet = false
    @State private var folderTitleInput: String = ""
    
    var body: some View {
        VStack {
            
                List {
                    Section {
                        NavigationLink {
                            FolderDetailView()
                        } label: {
                            HStack {
                                Image(systemName: "folder")
                                Text("Personal")
                            }
                        }
                    }
                    
                    if !$folderVM.data.isEmpty {
                        ForEach($folderVM.data) { folder in
                            Section {
                                NavigationLink {
                                    FolderDetailView(id: folder.id.uuidString)
                                } label: {
                                    HStack {
                                        Image(systemName: "folder")
                                        Text(folder.title.wrappedValue)
                                    }
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive, action: {
                                    habitVM.deleteHabitByFolder(id: folder.id.wrappedValue.uuidString)
                                    folderVM.deleteFolder(id: folder.id.wrappedValue.uuidString)
                                }, label: {
                                    Label("Delete", systemImage: "trash")
                                })
                            }
                        }
                    }
                    else {}
                }
                .listSectionSpacing(.compact)
            
        }
        .navigationTitle("Habit Journey")
        .searchable(text: $searchValue, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    DailyQuestView()
                } label: {
                    Image(systemName: "list.bullet.clipboard")
                }
                NavigationLink {
                    LineChartDetailView()
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    showCreateSheet.toggle()
                }, label: {
                    Image(systemName: "folder.badge.plus")
                })
                NavigationLink {
                    HabitDetailView()
                        .toolbarRole(.editor)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            NavigationStack{
                VStack {
                    TextField("Enter folder name", text: $folderTitleInput)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            showCreateSheet = false
                        } label: {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            folderVM.addFolder(newFolder: Folder(title: folderTitleInput))
                            folderTitleInput = ""
                            showCreateSheet = false
                        }, label: {
                            Text("Done")
                        })
                    }
                }
            }
            
        }
        .onAppear {
            habitVM.modelContext = modelContext
            folderVM.modelContext = modelContext
            
            folderVM.fetchAll()
            habitVM.fetchAll()
            
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


