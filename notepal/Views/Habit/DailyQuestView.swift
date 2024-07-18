//
//  DailyQuestView.swift
//  notepal
//
//  Created by Hansen Yudistira on 16/07/24.
//

import SwiftUI
import SwiftData

extension Date{
    func dailyQuestFormatted() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: self)
    }
}

struct DailyQuestView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var habitVM = HabitViewModel()
    
    @State private var searchValue = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            if !$habitVM.data.isEmpty {
                Text("\(Date.now.dailyQuestFormatted())")
                    .bold()
                    .padding(.horizontal)
                List {
                    ForEach($habitVM.data) { habit in
                        Section{
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
                .contentMargins(.vertical, 6)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listSectionSpacing(.compact)
            } else {
                Text("No items yet.")
                    .foregroundColor(.gray)
            }
        }
        .background(!$habitVM.data.isEmpty ? Color(UIColor.secondarySystemBackground) : .clear)
        .navigationTitle("Daily Quest")
        .searchable(text: $searchValue, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
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
