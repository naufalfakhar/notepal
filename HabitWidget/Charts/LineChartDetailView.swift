//
//  LineChartDetailView.swift
//  notepal
//
//  Created by Hansen Yudistira on 15/07/24.
//

import SwiftUI
import Charts

struct LineChartDetailView: View {
    @State var habitDataLogs: [HabitDataLog] = []
    @State var habitLastWeekLogs: [HabitDataLog] = []
    @State var completionRate: Float = 0.0
    @State var scheduled = 0
    @State var done = 0
    @State var missed = 0
    @State var lastWeekScheduled = 0
    @State var lastWeekDone = 0
    @State var lastWeekMissed = 0
    @State var lastWeekCompletionRate: Float = 0.0
    let habitManager = HabitManager()
    @State private var currentTab: CurrentTab = .thisWeek
    @Environment(\.modelContext) var modelContext
    
    var displayedScheduled: Int {
        switch currentTab {
        case .lastWeek:
            return lastWeekScheduled
        default:
            return scheduled
        }
    }

    var displayedDone: Int {
        switch currentTab {
        case .lastWeek:
            return lastWeekDone
        default:
            return done
        }
    }

    var displayedMissed: Int {
        switch currentTab {
        case .lastWeek:
            return lastWeekMissed
        default:
            return missed
        }
    }
    
    var displayedCompletionRate: Float {
        if displayedScheduled == 0 { return 0 }
        return Float(displayedDone) / Float(displayedScheduled)
    }
    
    var comparingDisplayedCompletionRate: Float {
        return Float(done) / Float(scheduled) - Float(lastWeekDone) / Float(lastWeekScheduled)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Check Habit Progress")
                        .font(.title3)
                    Spacer()
                    Picker("Select Tab", selection: $currentTab) {
                        ForEach(CurrentTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                HStack {
                    Text("My Habit Progression")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack {
                   Circle()
                       .foregroundColor(.blue)
                       .frame(width: 10, height: 10)
                   Text("Current Week")
                       .foregroundColor(.blue)
                       .font(.subheadline)
                   
                   Rectangle()
                       .foregroundColor(.black)
                       .frame(width: 10, height: 10)
                   Text("Last Week")
                       .foregroundColor(.black)
                       .font(.subheadline)
                   
                   Spacer()
               }
               .padding([.top, .leading, .trailing])
                
                LineChartView(habitDataLogs: habitDataLogs, habitLastWeekLogs: habitLastWeekLogs, currentTab: $currentTab)
                    .frame(height: 300)
                    .padding()
                
                HStack {
                    VStack {
                        Text("Scheduled")
                            .font(.subheadline)
                        Text("\(displayedScheduled)")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity)
//
//                    Divider()
//                            .frame(height: 50)
//                            .background(Color.gray)
                    
                    VStack {
                        Text("Done")
                            .font(.subheadline)
                        Text("\(displayedDone)")
                            .font(.title)
                            .foregroundStyle(Color.green)
                    }
                    .frame(maxWidth: .infinity)
//
//                    Divider()
//                            .frame(height: 50)
//                            .background(Color.gray)
//
                    VStack {
                        Text("Missed")
                            .font(.subheadline)
                        Text("\(displayedMissed)")
                            .font(.title)
                            .foregroundStyle(Color.red)
                    }
                    .frame(maxWidth: .infinity)
                }
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.center)
                
                HStack {
                    Text("Rate of completion = ")
                    Text("\(displayedCompletionRate * 100, specifier: "%.2f")%")
                        .fontWeight(.bold)
                    currentTab == .comparing ?
                        HStack(spacing: 0) {
                            Text("(")
                                .fontWeight(.bold)
                            Text("\(comparingDisplayedCompletionRate > 0 ? "+" : "-")\(String(format: "%.2f", abs(comparingDisplayedCompletionRate * 100)))%")
                                .foregroundStyle(comparingDisplayedCompletionRate > 0 ? Color.green : Color.red)
                                .fontWeight(.bold)
                            Text(")")
                                .fontWeight(.bold)
                        }
                        :
                        HStack {
                            Text("")
                            Text("")
                            Text("")
                        }
                    Spacer()
                 }
                .font(.footnote)
            }
            .padding()
        }
        .navigationTitle("Weekly Analysis")
        .padding()
        .onAppear {
            habitLastWeekLogs = habitManager.fetchHabitLogsForPastTwoWeek(modelContext: modelContext)
            habitDataLogs = habitManager.fetchHabitLogsForPastWeek(modelContext: modelContext)
            scheduled = habitDataLogs.reduce(0) { $0 + $1.scheduled }
            done = habitDataLogs.reduce(0) { $0 + $1.done }
            missed = habitDataLogs.reduce(0) { $0 + $1.missed }
            completionRate = Float(done) / Float(scheduled)
            lastWeekScheduled = habitLastWeekLogs.reduce(0) { $0 + $1.scheduled }
            lastWeekDone = habitLastWeekLogs.reduce(0) { $0 + $1.done }
            lastWeekMissed = habitLastWeekLogs.reduce(0) { $0 + $1.missed }
            lastWeekCompletionRate = Float(lastWeekDone) / Float(lastWeekScheduled)
        }
    }
}
