//
//  ToggleCheckboxStyle.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import SwiftUI
import Foundation

struct CheckboxStrikethrough: ToggleStyle {
//    @Binding var id: UUID
//    @Binding var model: Habit
    @Binding var text: String
    @FocusState var amountIsFocused: Bool
    var axis: Axis = .horizontal

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .top){
            Button(action: {
                configuration.isOn.toggle()
            }, label: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            }).foregroundStyle(.black)
            
            TextField(text: $text, axis: axis){}
                .strikethrough(configuration.isOn)
                .foregroundStyle(.black)
                .focused($amountIsFocused)
            //                .onSubmit {
            //                    if let index = model.plans.firstIndex(where: {$0.id == id}){
            //                        model.plans.insert(Checklist(content: ""), at: index + 1)
            //                    }
            //                }
        }
    }
}

