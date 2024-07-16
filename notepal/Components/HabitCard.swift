//
//  HabitCard.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 16/07/24.
//

import SwiftUI

struct HabitCard: View {
    @Binding var habit: Habit
    
    var body: some View {
        HStack {
            Image(systemName: "note.text")
            Text($habit.title.wrappedValue)
            Spacer()
            ZStack{
                Image(systemName: "flame")
                    .font(.system(size: 28))
                    .foregroundStyle(
                        .linearGradient(colors: [.orange, .red],
                                        startPoint: .top,
                                        endPoint: .bottom))
                Image(systemName: "flame.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(
                        .linearGradient(colors: [.orange, .red],
                                        startPoint: .top,
                                        endPoint: .bottom))
                Text("21")
                    .foregroundStyle(Color.white)
                    .offset(y:2)
            }
        }
    }
}

