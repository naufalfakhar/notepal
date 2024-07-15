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
        SimpleEntry(date: Date(), habitDataLogs: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), habitDataLogs: [])
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
    
            let habitLogs: [HabitLog] = try modelContainer.mainContext.fetch(FetchDescriptor<HabitLog>())
            
            let habitDataLogs = habitManager.fetchHabitLogsForPastWeek(logs: habitLogs)
            
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, habitDataLogs: habitDataLogs)
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } catch {
            print("Failed to fetch HabitLog: \(error)")
            let timeline = Timeline(entries: [SimpleEntry(date: Date(), habitDataLogs: [])], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let habitDataLogs: [HabitDataLog]
}

struct HabitWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            LineChartView(habitDataLogs: entry.habitDataLogs)
                .frame(height: 80)
                .padding()
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




//
//#Preview(as: .systemSmall) {
//    HabitWidget()
//} timeline: {
//    SimpleEntry(date: .now, habitDataLogs: [])
//}
