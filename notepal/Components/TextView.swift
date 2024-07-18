//
//  TextView.swift
//  notes
//
//  Created by Dason Tiovino on 12/07/24.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var attributedText: NSMutableAttributedString
    @State var allowsEditingTextAttributes: Bool = false
    @State var font: UIFont?
    @FocusState private var amountIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme

    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(parent: TextView) {
            self.parent = parent

        }

        func textViewDidChange(_ textView: UITextView) {
            parent.attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
            print("Text edited")
            
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
        uiView.allowsEditingTextAttributes = allowsEditingTextAttributes
        uiView.font = font
        
        
        // Update text color based on the current color scheme
        let textColor: UIColor = colorScheme == .dark ? .white : .black
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.foregroundColor, value: textColor, range: range)
        uiView.attributedText = attributedText
        
        print("UI Updated")
    }
}
