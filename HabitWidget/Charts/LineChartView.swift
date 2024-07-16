//
//  LineChartView.swift
//  notepal
//
//  Created by Hansen Yudistira on 14/07/24.
//

import Charts
import SwiftUI
import SwiftData

struct LineChartView: View {
    var habitDataLogs: [HabitDataLog]
    var habitLastWeekLogs: [HabitDataLog]
    @Binding var currentTab: CurrentTab
//    @Environment(\.modelContext) var modelContext
//    @State private var showModal = false
//    @State private var selectedDate: Date?
//    @State private var selectedHabitLog: HabitLog?
//    @State private var habitLogViewModel: HabitLogViewModel
    
//    init(habitDataLogs: [HabitDataLog], habitLastWeekLogs: [HabitDataLog], currentTab: Binding<CurrentTab>, modelContext: ModelContext) {
//        self.habitDataLogs = habitDataLogs
//        self.habitLastWeekLogs = habitLastWeekLogs
//        self._currentTab = currentTab
//        _habitLogViewModel = State(wrappedValue: HabitLogViewModel(modelContext: modelContext))
//    }

    var body: some View {
        VStack {
            Chart {
                if currentTab == .thisWeek {
                    ForEach(habitDataLogs, id: \.date) { log in
                        LineMark(
                            x: .value("Day", log.date, unit: .day),
                            y: .value("Habits Done", log.habitCount)
                        )
                        .foregroundStyle(Color.blue)
                        .symbol {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 10))
//                                .onTapGesture {
//                                    showModal = true
//                                    selectedDate = log.date
//                                    selectedHabitLog = habitLogViewModel.fetchHabitLog(for: selectedDate!)
//                                }
                        }
                    }
                } else if currentTab == .lastWeek {
                    ForEach(habitLastWeekLogs, id: \.date) { log in
                        LineMark(
                            x: .value("Day", log.date, unit: .day),
                            y: .value("Habits Done", log.habitCount)
                        )
                        .foregroundStyle(Color.black)
                        .symbol {
                            Image(systemName: "square.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 10))
//                                .onTapGesture {
//                                    showModal = true
//                                    selectedDate = log.date
//                                    selectedHabitLog = habitLogViewModel.fetchHabitLog(for: selectedDate!)
//                                }
                        }
                    }
                } else if currentTab == .comparing {
                    ForEach(habitLastWeekLogs, id: \.date) { log in
                        let adjustedDate = Calendar.current.date(byAdding: .day, value: 7, to: log.date) ?? log.date
                        LineMark(
                            x: .value("Day", adjustedDate, unit: .day),
                            y: .value("Habits Done", log.habitCount),
                            series: .value("This Week", "A")
                        )
                        .foregroundStyle(Color.black)
                        .symbol {
                            Image(systemName: "square.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 10))
//                                .onTapGesture {
//                                    showModal = true
//                                    selectedDate = adjustedDate
//                                    selectedHabitLog = habitLogViewModel.fetchHabitLog(for: selectedDate!)
//                                }
                        }
                    }
                    
                    ForEach(habitDataLogs, id: \.date) { log in
                        LineMark(
                            x: .value("Day", log.date, unit: .day),
                            y: .value("Habits Done", log.habitCount),
                            series: .value("Last Week", "B")
                        )
                        .foregroundStyle(Color.blue)
                        .symbol {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 10))
//                                .onTapGesture {
//                                    showModal = true
//                                    selectedDate = log.date
//                                    selectedHabitLog = habitLogViewModel.fetchHabitLog(for: selectedDate!)
//                                }
                        }
                    }
                }
            }
            .chartXAxisLabel("Day", position: .bottomTrailing)
            .chartYAxisLabel("Habits Done", position: .top)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.weekday(), centered: true)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYScale(domain: 0...5)
        }
//        .sheet(isPresented: $showModal) {
//            if let habitLog = selectedHabitLog {
//                HabitLogDetailView(habitLog: habitLog)
//                HabitLogDetailView()
//            } else {
//                Text("No data available")
//                    .font(.title)
//                    .padding()
//                Spacer()
//                Button(action: {
//                    showModal = false
//                }) {
//                    Text("Close")
//                        .font(.headline)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding()
//            }
//        }
    }
}
//
//struct HabitLogDetailView: View {
//    var habitLog: HabitLog
//
//    var body: some View {
//        VStack {
//            Text("Habit Log Details")
//                .font(.title)
//            List {
//                ForEach(Array(zip(habitLog.habitNameLogs, habitLog.habitCompleteLogs)), id: \.0) { habitName, habitComplete in
//                    HStack {
//                        Text(habitName)
//                        Spacer()
//                        Image(systemName: habitComplete ? "checkmark.circle.fill" : "xmark.circle.fill")
//                            .foregroundColor(habitComplete ? .green : .red)
//                    }
//                }
//            }
//            Spacer()
//            Button(action: {
//                // dismiss button later
//            }) {
//                Text("Close")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .padding()
//        }
//    }
//}
