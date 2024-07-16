//
//  DetailHabitView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 16/07/24.
//

import SwiftUI

struct DetailHabitView: View {
    @Bindable var habit: Habit
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $habit.title)
                .font(.largeTitle)
                .bold()
            
            Button(action: {
                // Action for Add to Calendar button
            }, label: {
                Text("Edit Calendar Event")
            })
            
            Divider()
            
            Section {
                Text("My Goals")
                    .font(.headline)
                    .bold()
                TextEditor(text: $habit.goal)
                    .padding(.horizontal, -4)
            }
            
            Section {
                Text("My Action Plan")
                    .font(.headline)
                    .bold()
//                TextEditor(text: $habit.plan)
//                    .padding(.horizontal, -4)
            }
            
            Section {
                Text("What I Need")
                    .font(.headline)
                    .bold()
//                TextEditor(text: $habit.need)
//                    .padding(.horizontal, -4)
            }
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    // TODO: Action here
                }, label: {
                    Image(systemName: "textformat")
                })
                
                Spacer()
                
                Button(action: {
                    // TODO: Action here
                }, label: {
                    Image(systemName: "checklist")
                })
                
                Spacer()
                
                Button(action: {
                    // TODO: Action here
                }, label: {
                    Image(systemName: "camera")
                })
                
                Spacer()
                
                Button(action: {
                    // TODO: Action here
                }, label: {
                    Image(systemName: "pencil.tip.crop.circle")
                })
                
            }
        }
    }
}

#Preview {
    DetailHabitView(habit: Habit(id: UUID(),
                                 title: "Cooking",
                                 goal: "Ingin sejago Gordon Ramsay"))
//                                 plan: "Masak sarapan setiap hari",
//                                 need: "Dapur dan peralatan masak")
}
