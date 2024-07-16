//
//  HabitWidget.swift
//  HabitWidget
//
//  Created by Hansen Yudistira on 13/07/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    let habitManager = HabitManager()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), habitDataLogs: [], habitLastWeekLogs: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), habitDataLogs: [], habitLastWeekLogs: [])
        completion(entry)
    }

    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        do {
            let schema = Schema([
                HabitLog.self,
                Habit.self,
                Note.self,
                Checklist.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let modelContext = modelContainer.mainContext
            
            let habitDataLogs = habitManager.fetchHabitLogsForPastWeek(modelContext: modelContext)
            let habitLastWeekLogs = habitManager.fetchHabitLogsForPastTwoWeek(modelContext: modelContext)
            
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, habitDataLogs: habitDataLogs, habitLastWeekLogs: habitLastWeekLogs, modelContext: modelContext)
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            print("Failed to fetch HabitLog: \(error)")
            let timeline = Timeline(entries: [SimpleEntry(date: Date(), habitDataLogs: [], habitLastWeekLogs: [])], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let habitDataLogs: [HabitDataLog]
    let habitLastWeekLogs: [HabitDataLog]
    var modelContext: ModelContext? = nil
}

struct HabitWidgetEntryView: View {
    var entry: Provider.Entry
    @State private var currentTab: CurrentTab = .thisWeek
    var displayedScheduled: Int {
        entry.habitDataLogs.reduce(0) { $0 + $1.scheduled }
    }
    
    var displayedDone: Int {
        entry.habitDataLogs.reduce(0) { $0 + $1.done }
    }
    
    var displayedMissed: Int {
        entry.habitDataLogs.reduce(0) { $0 + $1.missed }
    }
    
    @Environment(\.widgetFamily) var family
    @Environment(\.modelContext) var modelContext
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            CalculatedView(displayedScheduled: displayedScheduled, displayedDone: displayedDone, displayedMissed: displayedMissed)
        case .systemMedium:
            HStack {
                CalculatedView(displayedScheduled: displayedScheduled, displayedDone: displayedDone, displayedMissed: displayedMissed)
                LineChartView(habitDataLogs: entry.habitDataLogs, habitLastWeekLogs: entry.habitLastWeekLogs, currentTab: $currentTab)
                    .frame(height: 120)
            }
        case .systemLarge:
            VStack {
                CalculatedView(displayedScheduled: displayedScheduled, displayedDone: displayedDone, displayedMissed: displayedMissed)
                LineChartView(habitDataLogs: entry.habitDataLogs, habitLastWeekLogs: entry.habitLastWeekLogs, currentTab: $currentTab)
                    .frame(height: 120)
            }
        case .systemExtraLarge:
            VStack {
                CalculatedView(displayedScheduled: displayedScheduled, displayedDone: displayedDone, displayedMissed: displayedMissed)
                LineChartView(habitDataLogs: entry.habitDataLogs, habitLastWeekLogs: entry.habitLastWeekLogs, currentTab: $currentTab)
                    .frame(height: 120)
            }
        case .accessoryCircular:
            CalculatedView(displayedScheduled: displayedScheduled, displayedDone: displayedDone, displayedMissed: displayedMissed)
        case .accessoryRectangular:
            LineChartView(habitDataLogs: entry.habitDataLogs, habitLastWeekLogs: entry.habitLastWeekLogs, currentTab: $currentTab)
                .frame(height: 80)
        case .accessoryInline:
            LineChartView(habitDataLogs: entry.habitDataLogs, habitLastWeekLogs: entry.habitLastWeekLogs, currentTab: $currentTab)
                .frame(height: 80)
        @unknown default:
            LineChartView(habitDataLogs: entry.habitDataLogs, habitLastWeekLogs: entry.habitLastWeekLogs, currentTab: $currentTab)
                .frame(height: 100)
        }
    }
}

struct HabitWidget: Widget {
    let kind: String = "HabitWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HabitWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HabitWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Habit Tracker Widget")
        .description("Tracks the number of habits completed each day for the past week.")
    }
}
