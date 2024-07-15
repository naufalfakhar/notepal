//
//  LineChartView.swift
//  notepal
//
//  Created by Hansen Yudistira on 14/07/24.
//

import Charts
import SwiftUI

struct LineChartView: View {
    var habitDataLogs: [HabitDataLog]

    var body: some View {
        Chart {
            ForEach(habitDataLogs, id: \.date) { log in
                LineMark(
                    x: .value("Date", log.date),
                    y: .value("Completed Habits", log.habitCount)
                )
            }
        }
    }
}
