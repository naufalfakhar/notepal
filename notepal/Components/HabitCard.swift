//
//  HabitCard.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 16/07/24.
//

import SwiftUI
import SwiftData

struct HabitCard: View {
    @Binding var habit: Habit
    @Environment(\.modelContext) var modelContext
    @StateObject private var habitLogVM = HabitLogViewModel()
    @State var streakCount: Int = 0
    
    var body: some View {
        HStack {
            Image(systemName: "note.text")
            Text($habit.title.wrappedValue)
            Spacer()
            ZStack{
                FireStreakView(streakCount: streakCount)
                Text("\(streakCount)")
                    .foregroundStyle(Color.white)
                    .offset(y:2)
            }
        }
        .onAppear {
            habitLogVM.modelContext = modelContext
            habitLogVM.fetchAll()
            streakCount = habitLogVM.fetchStreak(title: habit.title)
        }
    }
}

