//
//  FlameView.swift
//  notepal
//
//  Created by Dason Tiovino on 17/07/24.
//

import SwiftUI

struct FlameView: View {
    var completionRate: Double
    @Environment(\.colorScheme) var colorScheme

    var gradient: LinearGradient {
        let colors: [Color] = calculateGradientColors(rate: completionRate)
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }

    func calculateGradientColors(rate: Double) -> [Color] {
        if rate <= 0.2 {
            let redColor = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.2 : 0.0) + rate, blue: colorScheme == .dark ? 0.2 : 0.0)
            let lightRed = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.1) + rate, blue: colorScheme == .dark ? 0.2 : 0)
            return [redColor, lightRed]
        } else if rate <= 0.4 {
            let lightRed = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.1) + rate, blue: colorScheme == .dark ? 0.2 : 0)
            let orange = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.1) + rate, blue: colorScheme == .dark ? 0.2 : 0)
            return [lightRed, orange]
        } else if rate <= 0.6 {
            let orange = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.1) + rate, blue: colorScheme == .dark ? 0.2 : 0.0)
            let yellow = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.6 : 0.1) + rate, blue: colorScheme == .dark ? 0.2 : 0.0)
            return [orange, yellow]
        } else if rate <= 0.8 {
            let yellow = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.6 : 0.1) + rate, blue: colorScheme == .dark ? 0.2 : 0.0)
            let lightBlue = Color(red: (colorScheme == .dark ? 1.5 : 1.3) - rate, green: (colorScheme == .dark ? 1.5 : 1.3) - rate, blue: colorScheme == .dark ? 1.2 : 1.0)
            return [yellow, lightBlue]
        } else if rate <= 1.0 {
            let lightBlue = Color(red: (colorScheme == .dark ? 1.5 : 1.3) - rate, green: (colorScheme == .dark ? 1.5 : 1.3) - rate, blue: colorScheme == .dark ? 1.2 : 1.0)
            let blue = Color(red: (colorScheme == .dark ? 0.8 : 0.5), green: (colorScheme == .dark ? 0.8 : 0.5), blue: rate)
            return [lightBlue, blue]
        } else {
            let lightBlue = Color(red: colorScheme == .dark ? 0.5 : 0.2, green: colorScheme == .dark ? 0.5 : 0.3, blue: colorScheme == .dark ? 1.2 : 1.0)
            let blue = Color(red: colorScheme == .dark ? 0.7 : 0.5, green: colorScheme == .dark ? 0.7 : 0.5, blue: colorScheme == .dark ? 1.2 : 1.0)
            return [lightBlue, blue]
        }
    }

    var body: some View {
        ZStack {
            Image(systemName: "flame")
                .foregroundStyle(gradient)
            Image(systemName: "flame.fill")
                .foregroundStyle(gradient)
        }
        .font(.system(size: 30))
    }
}
