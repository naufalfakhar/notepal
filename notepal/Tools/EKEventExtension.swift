//
//  EKEventExtension.swift
//  notepal
//
//  Created by Dason Tiovino on 16/07/24.
//

import EventKit

extension EKEvent {
    /// Creates a nonfloating event that uses the specified lesson, event store, calendar, start date, and end date.
    convenience init(habit: Habit, url: URL, eventStore store: EKEventStore, calendar: EKCalendar?, startDate: Date, endDate: Date) {
        self.init(eventStore: store)
        self.title = habit.title
        self.url = url
        self.calendar = calendar
        self.startDate = startDate
        self.endDate = endDate
    
        // A floating event is one that isn't associated with a specific time zone. Set `timeZone` to nil if you wish to have a floating event.
        self.timeZone = TimeZone.current
    }
}
