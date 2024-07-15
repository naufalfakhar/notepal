//
//  HabitCard.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import SwiftUI

struct HabitCard: View {
    @Binding var model: Habit
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(model.title)
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text(model.goal)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                
                ForEach($model.plans){ $list in
                    Toggle(
                        list.content,
                        isOn: $list.done
                    ).toggleStyle(ToggleCheckboxStyle(
                        text:$list.content
                    ))
                    .disabled(true)
                }
            }
            Spacer()
            NavigationLink(destination: {
                HabitDetailView(id: model.id.uuidString)
            }) {
//                Image(systemName: "chevron.compact.right")
//                    .foregroundColor(.black.opacity(0.5))
            }
        }
    }
}
