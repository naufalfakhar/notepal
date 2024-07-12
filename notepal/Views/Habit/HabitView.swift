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
    @State private var viewModel = HabitViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20){
                List{
                    ForEach($viewModel.folderData.filter{$0.wrappedValue.parentId == nil}){ folder in
                        FolderCard(
                            model: folder,
                            folderData: $viewModel.folderData,
                            data: $viewModel.data
                        )
                    }
                    ForEach($viewModel.data){content in
                        HabitCard(model: content)
                            .swipeActions{
                                Button("Delete", systemImage: "trash", role: .destructive){
                                    viewModel.deleteHabit(content.wrappedValue)
                                }
                            }
                    }
                }.listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .frame(
                maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                maxHeight: .infinity,
                alignment: Alignment(
                    horizontal: .leading, 
                    vertical: .top
                )
            )
            
            Button{
                viewModel.addHabit()
            } label:{
                Text("Add Habit")
            }
            Button{
                viewModel.addHabitToRandomFolder()
            } label:{
                Text("Add Habit to Folder")
            }
            Button{
                viewModel.addFolder()
            } label:{
                Text("Add Folder")
            }
            Button{
                viewModel.addSubFolder()
            } label:{
                Text("Add SubFolder")
            }
            Button{
                viewModel.addSubFolderFolder()
            }label:{
                Text("Add SubFolderFolder")
            }
            Button{
                viewModel.clearAll()
            }label:{
                Text("Clear All")
            }
        }
        .onAppear{
            viewModel.modelContext = modelContext
            viewModel.fetchHabitData()
            viewModel.fetchFolderData()
        }
    }
}

