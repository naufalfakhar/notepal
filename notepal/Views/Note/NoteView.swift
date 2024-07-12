//
//  NoteView.swift
//  notes
//
//  Created by Dason Tiovino on 10/07/24.
//

import Foundation
import SwiftUI
import SwiftData

extension Date{
    func noteFormatted() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}

struct NoteView: View {
    @Binding var model: Habit
    @State var isActive: Bool = false

    var body: some View {
        ZStack{
            ScrollView{
                    VStack(alignment: .leading){
                        Text(model.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack{
                            Text("Repeat")
                            Button{
                                isActive = true
                            }label:{
                                Text("Select")
                            }
                        }
                        
                        Divider()
                        
                        Text("My Goals")
                            .font(.headline)
                        
                        TextField(text: $model.goal){}
                        
                        Text("My Action Plan")
                            .font(.headline)
                        
                        ForEach($model.plans){ $list in
                            Toggle(
                                list.content,
                                isOn: $list.done
                            ).toggleStyle(ToggleCheckboxStyle(
                                text: $list.content,
                                axis: .vertical
                            ))
                        }
                        Divider()
                        ForEach($model.note.contents) { $note in
                            VStack(alignment: .leading) {
                                
                                Text(note.createdAt.noteFormatted())
                                    .font(.headline)
                                
                                TextView(
                                    attributedText: $note.content,
                                    allowsEditingTextAttributes: true,
                                    font: .systemFont(ofSize: 24)
                                )
                                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                            }
                            .padding(.vertical)
                        }
                    }.padding(.horizontal)
            }
            
            if isActive {
                RepeatNoteView(isActive: $isActive)
            }
        }
    }
}

