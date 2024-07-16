//
//  ToggleCheckboxStyle.swift
//  notes
//
//  Created by Dason Tiovino on 09/07/24.
//

import SwiftUI
import Foundation

struct CheckboxStrikethrough: ToggleStyle {
    @Binding var text: String
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
        }
        
    }
}

