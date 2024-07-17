//
//  DailyQuestView.swift
//  notepal
//
//  Created by Hansen Yudistira on 16/07/24.
//

import SwiftUI
import SwiftData

struct DailyQuestView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var habitVM = HabitViewModel()
    
    @State private var searchValue = ""
    
    var body: some View {
        VStack {
            if !$habitVM.data.isEmpty {
                List {
                    ForEach($habitVM.data) { habit in
                        Section {
                            NavigationLink {
                                HabitDetailView(id: habit.id.uuidString)
                                    .toolbarRole(.editor)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                HabitCard(habit: habit)
                            }
                        }
                    }
                }
                .listSectionSpacing(.compact)
            } else {
                Text("No items yet.")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Daily Quest")
        .searchable(text: $searchValue, prompt: "Search")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    LineChartDetailView()
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                }
            }
        }
        .onAppear {
            habitVM.modelContext = modelContext
            
            habitVM.fetchAll()
        }
    }
}
