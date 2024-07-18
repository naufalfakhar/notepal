//
//  FireStreakView.swift
//  HabitDaily
//
//  Created by Hansen Yudistira on 12/07/24.
//

import SwiftUI

struct FireStreakView: View {
    var streakCount: Int
    var body: some View {
        let completionRate = Double(streakCount) / 21.0
        if completionRate <= 0 {
            Text("")
        } else {
            ZStack {
                FlameView(completionRate: completionRate)
            }
        }
    }
}

#Preview {
    FireStreakView(streakCount: 1)
}

