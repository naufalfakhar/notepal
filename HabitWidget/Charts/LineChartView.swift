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
    @Environment(\.colorScheme) var colorScheme
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
                        }
                    }
                } else if currentTab == .lastWeek {
                    ForEach(habitLastWeekLogs, id: \.date) { log in
                        LineMark(
                            x: .value("Day", log.date, unit: .day),
                            y: .value("Habits Done", log.habitCount)
                        )
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        .symbol {
                            Image(systemName: "square.fill")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: 10))
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
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        .symbol {
                            Image(systemName: "square.fill")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: 10))
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
    }
}
