////
////  HabitDailyWidget.swift
////  notepal
////
////  Created by Hansen Yudistira on 14/07/24.
////
//
//import WidgetKit
//import SwiftUI
//import SwiftData
//
//struct DailyProvider: IntentTimelineProvider {
//    typealias Intent = SelectHabitIntent
//    
//    typealias Entry = DailyEntry
//    
//    let habitManager = HabitManager()
//    
//    func placeholder(in context: Context) -> DailyEntry {
//        DailyEntry(date: Date(), habitData: [])
//    }
//
//    func getSnapshot(for configuration: SelectHabitIntent, in context: Context, completion: @escaping (DailyEntry) -> ()) {
//        let entry = DailyEntry(date: Date(), habitData: [])
//        completion(entry)
//    }
//
//    @MainActor
//    func getTimeline(for configuration: SelectHabitIntent, in context: Context, completion: @escaping (Timeline<DailyEntry>) -> ()) {
//        do {
//            let schema = Schema([
//                HabitLog.self,
//                Habit.self,
//                Note.self,
//                Checklist.self,
//            ])
//            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
//    
//            let habit: [Habit] = try modelContainer.mainContext.fetch(FetchDescriptor<Habit>())
//            
//            let habitData = habitManager.fetchHabitDaily(data: habit)
//            
//            let currentDate = Date()
//            let entry = DailyEntry(date: currentDate, habitData: habitData)
//            
//            let timeline = Timeline(entries: [entry], policy: .atEnd)
//            completion(timeline)
//        } catch {
//            print("Failed to fetch HabitLog: \(error)")
//            let timeline = Timeline(entries: [DailyEntry(date: Date(), habitData: [])], policy: .atEnd)
//            completion(timeline)
//        }
//    }
//}
//
//struct DailyEntry: TimelineEntry {
//    let date: Date
//    let habitData: [HabitData]
//}
//
//struct HabitDailyWidgetEntryView: View {
//    var entry: DailyProvider.Entry
//
//    var body: some View {
//        NavigationView {
//            List(entry.habitData) { habit in
//                NavigationLink(destination: HabitCardView(habitTitle: habit.title)) {
//                    Text(habit.title)
//                        .padding()
//                }
//            }
//            .navigationTitle("Daily Habits")
//        }
//    }
//}
//
//struct HabitDailyWidget: Widget {
//    let kind: String = "HabitDailyWidget"
//
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: SelectHabitIntent.self, provider: DailyProvider()) { entry in
//            if #available(iOS 17.0, *) {
//                HabitDailyWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                HabitDailyWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
//        }
//        .configurationDisplayName("Habit Daily Quest Widget")
//        .description("Complete Daily Quest Given.")
//    }
//}
