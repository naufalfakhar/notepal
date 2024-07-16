//
//  FolderDetailView.swift
//  notepal
//
//  Created by Dason Tiovino on 16/07/24.
//

import SwiftUI

struct FolderDetailView: View {
    
    var id: String
    @Environment(\.modelContext) var modelContext

    @StateObject private var habitViewModel = HabitViewModel()
    @StateObject private var folderViewModel = FolderViewModel()
    @State private var searchValue = ""
    
    var body: some View {
        VStack {
            if !$habitViewModel.data.isEmpty || !$folderViewModel.data.isEmpty {
                if let data = folderViewModel.data.first{
                    List {
    //                    ForEach($folderViewModel.data) { folder in
    //                        Section {
    //                            NavigationLink {
    //                                FolderDetailView()
    //                            } label: {
    //                                HStack {
    //                                    Image(systemName: "folder")
    //                                    Text(folder.title.wrappedValue)
    //                                }
    //                            }
    //                        }
    //                    }
                        ForEach($habitViewModel.data.filter{$0.wrappedValue.folderId == data.id}) { habit in
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
                }
                else{
                    
                }
                
            } else {
                Text("No items yet.")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(folderViewModel.data.first?.title ?? "Habit Journey")
        .searchable(text: $searchValue, prompt: "Search")
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
                    HabitDetailView(folderId: folderViewModel.data.first?.id.uuidString)
                        .toolbarRole(.editor)
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .onAppear {
            habitViewModel.modelContext = modelContext
            folderViewModel.modelContext = modelContext
            
            folderViewModel.fetchById(id: id)
            habitViewModel.fetchAll()
            
        }
    }
}

