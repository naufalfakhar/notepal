//
//  FireStreakView.swift
//  HabitDaily
//
//  Created by Hansen Yudistira on 12/07/24.
//

import SwiftUI

struct DateStatus {
    var date: Date
    var status: Bool
}

struct Streak {
    var habit1: [DateStatus]
    var habit2: [DateStatus]
    var habit3: [DateStatus]
}

func createJulyDatesWithStatus() -> [DateStatus] {
    var dateStatuses: [DateStatus] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    for day in 1...21 {
        if let date = dateFormatter.date(from: "2024-07-\(String(format: "%02d", day))") {
            let status = Bool.random()
            dateStatuses.append(DateStatus(date: date, status: status))
        }
    }
    return dateStatuses
}

func relativeLuminance(of color: UIColor) -> CGFloat {
    let components = color.cgColor.components!
    let r = components[0]
    let g = components[1]
    let b = components[2]
    
    let red = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4)
    let green = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4)
    let blue = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4)
    
    return 0.2126 * red + 0.7152 * green + 0.0722 * blue
}

func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
    let luminance1 = relativeLuminance(of: color1)
    let luminance2 = relativeLuminance(of: color2)
    
    return (max(luminance1, luminance2) + 0.05) / (min(luminance1, luminance2) + 0.05)
}

struct FlameView: View {
    var completionRate: Double
    @Environment(\.colorScheme) var colorScheme

    var gradient: LinearGradient {
        let colors: [Color] = calculateGradientColors(rate: completionRate)
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }

    func calculateGradientColors(rate: Double) -> [Color] {
        if rate <= 0.2 {
            let redColor = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.2 : 0) + rate, blue: colorScheme == .dark ? 0.2 : 0)
            let lightRed = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.3) + rate, blue: colorScheme == .dark ? 0.2 : 0)
            return [redColor, lightRed]
        } else if rate <= 0.4 {
            let lightRed = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.2) + rate, blue: colorScheme == .dark ? 0.2 : 0)
            let orange = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.2) + rate, blue: colorScheme == .dark ? 0.2 : 0)
            return [lightRed, orange]
        } else if rate <= 0.6 {
            let orange = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.5 : 0.2) + rate, blue: colorScheme == .dark ? 0.2 : 0.0)
            let yellow = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.6 : 0.3) + rate, blue: colorScheme == .dark ? 0.2 : 0.0)
            return [orange, yellow]
        } else if rate <= 0.8 {
            let yellow = Color(red: (colorScheme == .dark ? 1.2 : 1.0), green: (colorScheme == .dark ? 0.6 : 0.4) + rate, blue: colorScheme == .dark ? 0.2 : 0.4)
            let lightBlue = Color(red: (colorScheme == .dark ? 1.5 : 1.2) - rate, green: (colorScheme == .dark ? 1.5 : 1.2) - rate, blue: colorScheme == .dark ? 1.2 : 1.0)
            return [yellow, lightBlue]
        } else if rate <= 1.0 {
            let lightBlue = Color(red: (colorScheme == .dark ? 1.5 : 1.2) - rate, green: (colorScheme == .dark ? 1.5 : 1.2) - rate, blue: colorScheme == .dark ? 1.2 : 1.0)
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
        .font(.system(size: 150))
        .onAppear {
            let startColor = UIColor(calculateGradientColors(rate: completionRate).first ?? .black)
            let endColor = UIColor(calculateGradientColors(rate: completionRate).last ?? .black)
            let contrast = contrastRatio(between: startColor, and: endColor)
            print("Contrast ratio: \(contrast)")
        }
    }
}

struct FireStreakView: View {
    var body: some View {
        let datesWithStatus = createJulyDatesWithStatus()
        let streak = Streak(habit1: datesWithStatus, habit2: datesWithStatus, habit3: datesWithStatus)
//        let completionRate1 = Double(streak.habit1.filter { $0.status }.count) / 21.0
//        let completionRate2 = Double(streak.habit2.filter { $0.status }.count) / 21.0
//        let completionRate3 = Double(streak.habit3.filter { $0.status }.count) / 21.0
        let completionRate1 = Double (19.0 / 21.0)
        let completionRate2 = Double (20.0 / 21.0)
        let completionRate3 = Double (21.0 / 21.0)
        ZStack {
            FlameView(completionRate: completionRate1)
                .offset(x: 0, y: -200)
            FlameView(completionRate: completionRate2)
            FlameView(completionRate: completionRate3)
                .offset(x: 0, y: 200)
        }
        .font(.system(size: 150))
    }
}

#Preview {
    FireStreakView()
}

