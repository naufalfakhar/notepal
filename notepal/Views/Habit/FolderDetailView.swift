//
//  FolderDetailView.swift
//  notepal
//
//  Created by Dason Tiovino on 16/07/24.
//

import SwiftUI

struct FolderDetailView: View {
    
    var id: String?
    @Environment(\.modelContext) var modelContext
    
    @StateObject private var habitVM = HabitViewModel()
    @StateObject private var folderVM = FolderViewModel()
    @State private var searchValue = ""
    
    var body: some View {
        VStack {
            if !$habitVM.data.isEmpty || !$folderVM.data.isEmpty {
                if let data = folderVM.data.first{
                    List {
                        ForEach($habitVM.data.filter{$0.wrappedValue.folderId == data.id}) { habit in
                            Section {
                                NavigationLink {
                                    HabitDetailView(id: habit.id.uuidString)
                                        .toolbarRole(.editor)
                                        .navigationBarTitleDisplayMode(.inline)
                                } label: {
                                    HabitCard(habit: habit)
                                }
                            }.swipeActions {
                                Button(role: .destructive, action: {
                                    habitVM.deleteHabit(id: habit.id.wrappedValue.uuidString)
                                }, label: {
                                    Label("Delete", systemImage: "trash")
                                })
                            }
                        }
                    }
                    .listSectionSpacing(.compact)
                }
                else{
                    List {
                        ForEach($habitVM.data.filter{$0.wrappedValue.folderId == nil}) { habit in
                            Section {
                                NavigationLink {
                                    HabitDetailView(id: habit.id.uuidString)
                                        .toolbarRole(.editor)
                                        .navigationBarTitleDisplayMode(.inline)
                                } label: {
                                    HabitCard(habit: habit)
                                }
                            }.swipeActions {
                                Button(role: .destructive, action: {
                                    habitVM.deleteHabit(id: habit.id.wrappedValue.uuidString)
                                }, label: {
                                    Label("Delete", systemImage: "trash")
                                })
                            }
                        }
                    }
                    .listSectionSpacing(.compact)
                }
                
            } else {
                Text("No items yet.")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(folderVM.data.first?.title ?? "Personal")
        .searchable(text: $searchValue, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                // Add Folder
                Button(action: {
                    //                    showCreateSheet.toggle()
                }, label: {
                    Image(systemName: "folder.badge.plus")
                        .tint(.clear)
                })
                NavigationLink {
                    HabitDetailView(folderId: folderVM.data.first?.id.uuidString)
                        .toolbarRole(.editor)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .onAppear {
            habitVM.modelContext = modelContext
            folderVM.modelContext = modelContext
            
            if id != nil {
                folderVM.fetchById(id: id!)
            }
            habitVM.fetchAll()
            
        }
    }
}

