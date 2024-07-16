//
//  HabitCardView.swift
//  notepal
//
//  Created by Hansen Yudistira on 14/07/24.
//

import SwiftUI
import SwiftData

struct HabitCardView: View {
    let habitTitle: String
        @State private var habit: Habit? = nil
        let habitCardViewModel = HabitCardViewModel()

        var body: some View {
            VStack(alignment: .leading) {
                if let habit = habit {
                    Text(habit.title)
                        .font(.headline)
                        .foregroundStyle(.black)

                    Text(habit.goal)
                        .font(.subheadline)
                        .foregroundStyle(.black)
                } else {
                    Text("Loading...")
                        .onAppear {
                            // Load Habit data from model context based on habitTitle
                            self.loadHabit()
                        }
                }
            }
            .onAppear {
                if self.habit == nil {
                    self.loadHabit()
                }
            }
        }

    @MainActor private func loadHabit() {
        habit = habitCardViewModel.fetchHabit(for: habitTitle)
    }
}
